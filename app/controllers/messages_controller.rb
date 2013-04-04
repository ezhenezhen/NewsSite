class MessagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  # GET /messages
  # GET /messages.json
  def my_messages
    @messages = Message.where(:user_id=>current_user.id)
    render 'index'
  end

  def upvote
    @message = Message.find params[:id]
    current_user.up_vote(@message)
    flash[:notice] = 'Thanks for voting!'
    respond_to do |format|
      format.html { redirect_to @message }
      format.js {}
    end

    rescue MakeVoteable::Exceptions::AlreadyVotedError
    flash[:error] = 'Already voted!'
    respond_to do |format|
      format.html { redirect_to @message }
    end
    end

  def downvote
    @message = Message.find params[:id]
    current_user.down_vote(@message)
    flash[:notice] = 'Thanks for voting!'
    redirect_to @message
  rescue MakeVoteable::Exceptions::AlreadyVotedError
    flash[:error] = 'Already voted!'
    redirect_to @message
    end

  def index
    @messages = Message.order("up_votes - down_votes DESC" , "created_at DESC").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
    if current_user.id == @message.user_id
    else
        redirect_to messages_path
    flash[:error] = "you can't modify or delete aliens news"
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    params[:message][:user_id] = current_user.id
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])
    if current_user.id == @message.user_id
      respond_to do |format|
        if @message.update_attributes(params[:message])
          format.html { redirect_to @message, notice: 'Message was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to message_path
      flash[:notice] = "you can't modify or delete aliens news"
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    if current_user.id == @message.user_id
      @message.destroy

      respond_to do |format|
        format.html { redirect_to messages_url }
        format.json { head :no_content }
      end
    else
      redirect_to messages_path
    flash[:error] = "you can't modify or delete aliens news"
  end
  end
end
