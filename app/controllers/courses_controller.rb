class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @week = {
      "sunday" => [],
      "monday" => [],
      "tuesday" => [],
      "wednesday" => [],
      "thursday" => [],
      "friday" => [],
      "saturday" => []
    }

    @course.time_blocks.each do |block|
      @week[block.week_day.downcase] << block
    end

  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    @week = week_params


    respond_to do |format|
      if @course.save
        @week.each do |day, value|
          time_block = TimeBlock.new(time_block_params)
          time_block.week_day = day
          time_block.course_id = @course.id
          time_block.save
        end
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :course_id, :instructor, :description, :room_id)
    end

     # Only allow a list of trusted parameters through.
    def time_block_params
      params.require(:time_block).permit(:week_day, :start_time, :end_time, :course_id)
    end

    def week_params
      params.require(:week).permit(:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday)
    end
end
