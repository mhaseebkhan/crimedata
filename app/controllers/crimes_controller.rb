require 'rest_client'

class CrimesController < ApplicationController
  # GET /crimes
  # GET /crimes.json
  def index
    @crimes = Crime.all

    crime_data_from_api = RestClient.get 'http://data.cityofchicago.org/resource/ijzp-q8t2.json'
    @crime_data = JSON.parse(crime_data_from_api)

    @crime_type = @crime_data.map{|crime| crime['primary_type']}.uniq
    @crime_year = @crime_data.map{|crime| crime['year']}.uniq
    result = Crime.json_converion_for_maps @crime_type, @crime_data, 'primary_type'
    @crime = result[0]
    @crime_type_array = result[1]

    result_by_year = Crime.json_converion_for_maps @crime_year, @crime_data, 'year'
    @crime_by_year = result_by_year[0]
    @crime_by_year_array = result_by_year[1]

    respond_to do |format|
      format.html # index-old.html.erb
      format.json { render json: @crimes }
    end
  end

  # GET /crimes/1
  # GET /crimes/1.json
  def show
    @crime = Crime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @crime }
    end
  end

  # GET /crimes/new
  # GET /crimes/new.json
  def new
    @crime = Crime.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @crime }
    end
  end

  # GET /crimes/1/edit
  def edit
    @crime = Crime.find(params[:id])
  end

  # POST /crimes
  # POST /crimes.json
  def create
    @crime = Crime.new(params[:crime])

    respond_to do |format|
      if @crime.save
        format.html { redirect_to @crime, notice: 'Crime was successfully created.' }
        format.json { render json: @crime, status: :created, location: @crime }
      else
        format.html { render action: "new" }
        format.json { render json: @crime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /crimes/1
  # PUT /crimes/1.json
  def update
    @crime = Crime.find(params[:id])

    respond_to do |format|
      if @crime.update_attributes(params[:crime])
        format.html { redirect_to @crime, notice: 'Crime was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @crime.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crimes/1
  # DELETE /crimes/1.json
  def destroy
    @crime = Crime.find(params[:id])
    @crime.destroy

    respond_to do |format|
      format.html { redirect_to crimes_url }
      format.json { head :ok }
    end
  end
end
