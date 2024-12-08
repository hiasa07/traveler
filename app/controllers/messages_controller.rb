class MessagesController < ApplicationController
    before_action :set_user
  
    def index
      @messages = Message.where(sender: current_user, receiver: @user)
                         .or(Message.where(sender: @user, receiver: current_user))
                         .order(:created_at)
      @new_message = Message.new
    end
  
    def create
      @message = current_user.sent_messages.build(receiver: @user, content: params[:message][:content])
    
      if @message.save
        redirect_to user_messages_path(@message.sender_id), notice: "メッセージを送信しました！"
      else
        @messages = Message.where(sender: current_user, receiver: @user)
                           .or(Message.where(sender: @user, receiver: current_user))
                           .order(:created_at)
        flash.now[:alert] = @message.errors.full_messages.join(", ")
        render :index
      end
    end    
  
    private
    def set_user
      @user = User.find(params[:user_id])
    end
  end  
