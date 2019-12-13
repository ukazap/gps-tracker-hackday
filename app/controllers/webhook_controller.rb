class WebhookController < ApplicationController
    def receive
        byebug
        head :ok
    end
end
