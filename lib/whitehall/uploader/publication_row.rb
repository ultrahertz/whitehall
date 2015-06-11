module Whitehall::Uploader
  class PublicationRow < Row
    def self.validator
      super
        .multiple("document_collection_#", 0..4)
        .required(%w{publication_type publication_date})
        .optional(%w{order_url price isbn urn command_paper_number}) # First attachment
        .optional(%w{hoc_paper_number parliamentary_session unnumbered_hoc_paper unnumbered_command_paper}) # First attachment
        .ignored("ignore_*")
        .multiple(%w{attachment_#_url attachment_#_title}, 0..Row::ATTACHMENT_LIMIT)
        .optional('json_attachments')
        .multiple("country_#", 0..4)
        .optional(%w(html_title html_body))
        .multiple('html_body_#', 0..99)
        .multiple("topic_#", 0..4)
    end

    def first_published_at
      Parsers::DateParser.parse(row['publication_date'], @logger, @line_number)
    end

    def publication_type
      Finders::PublicationTypeFinder.find(row['publication_type'], @logger, @line_number)
    end

    def document_collections
      fields(1..4, 'document_collection_#').compact.reject(&:blank?)
    end

    def attachments
      if @attachments.nil?
        @attachments = attachments_from_columns + attachments_from_json
        apply_meta_data_to_attachment(@attachments.first) if @attachments.any?
      end
      @attachments
    end

    def alternative_format_provider
      organisations.first
    end

    def world_locations
      Finders::WorldLocationsFinder.find(row['country_1'], row['country_2'], row['country_3'], row['country_4'], @logger, @line_number)
    end

    def html_title
      row['html_title']
    end

    def html_body
      if row['html_body']
        ([row['html_body']] + (1..99).map {|n| row["html_body_#{n}"] }).compact.join
      end
    end

    def html_attachment_attributes
      { title: html_title, govspeak_content_attributes: { body: html_body } }
    end

  protected
    def attribute_keys
      super + [
        :alternative_format_provider,
        :attachments,
        :first_published_at,
        :html_attachment_attributes,
        :lead_organisations,
        :publication_type,
        :topics,
        :world_locations
      ]
    end

  private

    def attachments_from_json
      if row["json_attachments"]
        attachment_data = ActiveSupport::JSON.decode(row["json_attachments"])
        attachment_data.map do |attachment|
          Builders::AttachmentBuilder.build({title: attachment["title"]}, attachment["link"], @attachment_cache, @logger, @line_number)
        end
      else
        []
      end
    end

    def apply_meta_data_to_attachment(attachment)
      attachment.order_url = row["order_url"]
      attachment.isbn = row["isbn"]
      attachment.unique_reference = row["urn"]
      attachment.command_paper_number = row["command_paper_number"]
      attachment.price = row["price"]
      attachment.hoc_paper_number = row["hoc_paper_number"]
      attachment.parliamentary_session = row["parliamentary_session"]
      attachment.unnumbered_hoc_paper = row["unnumbered_hoc_paper"]
      attachment.unnumbered_command_paper = row["unnumbered_command_paper"]
    end
  end
end
