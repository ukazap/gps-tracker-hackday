class WebhookController < ApplicationController
    def receive
        $received_from_webhook = params
        head :ok
    end
end
