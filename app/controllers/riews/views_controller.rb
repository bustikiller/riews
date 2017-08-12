require_dependency "riews/application_controller"

module Riews
  class ViewsController < ApplicationController
    before_action :set_view, only: [:show, :edit, :update, :destroy]

    # GET /views
    def index
      @views = View.all
    end

    # GET /views/1
    def show
      @page = params[:page]
    end

    # GET /views/new
    def new
      @view = View.new
    end

    # GET /views/1/edit
    def edit
    end

    # POST /views
    def create
      @view = View.new(view_params)

      if @view.save
        redirect_to @view, notice: 'View was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /views/1
    def update
      if @view.update(view_params)
        redirect_to @view, notice: 'View was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /views/1
    def destroy
      @view.destroy
      redirect_to views_url, notice: 'View was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_view
        @view = View.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def view_params
        params.require(:view).permit(:name, :model, :code)
      end
  end
end
