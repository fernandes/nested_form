module Theme
  module Cell
    class Layout < Trailblazer::Cell
      self.prefixes << 'app/concepts/theme/view/layout'
      include ActionView::Helpers::CsrfHelper
      include ActionView::Helpers::CspHelper
      include Webpacker::Helper

      def show(&block)
        variation = context.fetch(:layout_variation, :default)
        render variation, &block
      end

      def protect_against_forgery?
        context[:controller].send(:protect_against_forgery?)
      end

      def content_security_policy?
        context[:controller].send(:content_security_policy?)
      end

      def form_authenticity_token
        context[:controller].send(:form_authenticity_token)
      end

      def flash_messages(opts = {})
        flash_messages = []
        controller.flash.each do |type, message|
          type = 'success' if type == 'notice'
          type = 'error'   if type == 'alert'
          text = "<script>toastr.#{type}('#{message}');</script>"
          flash_messages << text.html_safe if message
        end
        flash_messages.join("\n").html_safe
      end
    end
  end
end
