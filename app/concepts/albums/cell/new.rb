module Albums::Cell
  class New < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper

    private
      def ibox_title
        "Album"
      end

      def form_submit_label
        "Save"
      end

      def form_path
        albums_path
      end

  end
end
