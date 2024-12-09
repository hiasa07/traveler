class MessagesController < ApplicationController
  before_action :set_user
  
  def index
    @messages = Message.where(sender: current_user, receiver: @user)
                       .or(Message.where(sender: @user, receiver: current_user))
                       .order(:created_at)
    @new_message = Message.new
  end

  def create
    if @user.present?
      @message = current_user.sent_messages.build(receiver: @user, content: params[:message][:content])
      
      if @message.save
        redirect_to user_messages_path(@user), notice: "メッセージを送信しました！"
      else
        @messages = Message.where(sender: current_user, receiver: @user)
                           .or(Message.where(sender: @user, receiver: current_user))
                           .order(:created_at)
        flash.now[:alert] = "メッセージの送信に失敗しました: " + @message.errors.full_messages.join(", ")
        render :index
      end
    else
      redirect_to root_path, alert: "相手ユーザーが見つかりませんでした。" and return
    end
  end    

  private
  def set_user
    user = User.find_by(id: params[:user_id])
    redirect_to root_path, alert: "ユーザーが見つかりませんでした。" unless @user
  end
end