class DisplaysController < ApplicationController
  before_action :set_display, only: [:show, :edit, :update, :destroy]

  # GET /displays
  # GET /displays.json
  def index
    @displays = Display.order("title" => "asc").all
  end

  # GET /displays/1
  # GET /displays/1.json
  def show
    @display = Display.friendly.find(params[:id])
  end

  # GET /displays/new
  def new
    @display = Display.new
  end

  # GET /displays/1/edit
  def edit
  end

  # POST /displays
  # POST /displays.json
  def create
    @display = Display.new(display_params)

    respond_to do |format|
      if @display.save
        format.html { redirect_to @display, notice: 'Display was successfully created.' }
        format.json { render :show, status: :created, location: @display }
      else
        format.html { render :new }
        format.json { render json: @display.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /displays/1
  # PATCH/PUT /displays/1.json
  def update
    respond_to do |format|
      if @display.update(display_params)
        format.html { redirect_to @display, notice: 'Display was successfully updated.' }
        format.json { render :show, status: :ok, location: @display }
      else
        format.html { render :edit }
        format.json { render json: @display.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /displays/1
  # DELETE /displays/1.json
  def destroy
    @display.destroy
    respond_to do |format|
      format.html { redirect_to displays_url, notice: 'Display was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_display
      @display = Display.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def display_params
      params.require(:display).permit(:title, :description)
    end
end
