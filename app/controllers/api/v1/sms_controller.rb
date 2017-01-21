# frozen_string_literal: true
module Api
  module V1
    class SmsController < BaseController
      before_action :authorize_sender
      after_action :verify_authorized, only: []

      api :POST, '/sms/receive', 'Receive SMS'
      description 'Receives SMS and adds it to the appropiate chat'
      error code: 400, desc: 'Bad request'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable entity'
      param :ja_key, String, desc: 'Auth key (can be an URL param)', required: true
      param :From, String, desc: 'To SMS address', required: true
      param :Body, String, desc: 'Email body', required: true
      def receive
        message_body = params['Body']
        from_number = params['From']

        user = User.includes(:language).find_by(phone: from_number)
        support_user = User.main_support_user

        if user && support_user
          create_chat_message(author: user, receiver: support_user, body: message_body)
        end

        head :no_content
      end

      private

      def authorize_sender
        return if params['ja_key'] == AppSecrets.incoming_sms_key

        render json: Unauthorized.add, status: :unauthorized
      end

      def create_chat_message(author:, receiver:, body:)
        chat = Chat.find_or_create_private_chat([author, receiver])
        CreateChatMessageService.create(
          chat: chat,
          author: author,
          body: body,
          language_id: author.language&.id
        )
      end
    end
  end
end
