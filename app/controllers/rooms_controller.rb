class RoomsController < ApplicationController
  require 'rqrcode'
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.order("name" => "asc").all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    courses = Course.where(room_id: @room.id).all
    # TODO: Abstract to application controller
    @week = {
      sunday: [],
      monday: [],
      tuesday: [],
      wednesday: [],
      thursday: [],
      friday: [],
      saturday: []
    }

    courses.each do |course|
      course.time_blocks.each do |block|
        @week[block.week_day.downcase.to_sym] << block
      end
    end

  end

  # GET /rooms/new
  def new
    @room = Room.new
    Rails.logger.info "***\n\n\n\n\nGenerate QR CODE\n\n\n\n\n***"
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    Rails.logger.info "***\n\n\n\n\nGenerate QR CODE\n\n\n\n\n***"

    respond_to do |format|
      if @room.save
        generate_qr
        format.html { redirect_to rooms_path, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to rooms_path, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:name, :title, :description)
    end

    def generate_qr
      qrcode = RQRCode::QRCode.new(TegrQR::DOMAIN + room_path(@room))
      Rails.logger.info "*** Generate QR CODE ***"

      # NOTE: showing with default options specified explicitly
      svg = qrcode.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 6,
        standalone: true)

      save_svg(svg, @room.id)
    end
end