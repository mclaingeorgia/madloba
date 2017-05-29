class GreetingsController < ApplicationController
  before_action :set_greeting, only: [:show, :edit, :update, :destroy]

  # GET /greetings
  def index
    @greetings = Greeting.all
  end

  # GET /greetings/1
  def show
  end

  # GET /greetings/new
  def new
    @greeting = Greeting.new
  end

  # GET /greetings/1/edit
  def edit
  end

  # POST /greetings
  def create
    @greeting = Greeting.new(greeting_params)

    if @greeting.save
      redirect_to @greeting, notice: 'Greeting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /greetings/1
  def update
    if @greeting.update(greeting_params)
      redirect_to @greeting, notice: 'Greeting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /greetings/1
  def destroy
    @greeting.destroy
    redirect_to greetings_url, notice: 'Greeting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_greeting
      @greeting = Greeting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def greeting_params
      params[:greeting]
    end
end
