require_dependency "riews/application_controller"

module Riews
  class ColumnsController < ApplicationController
    load_and_authorize_resource :view
    before_action :set_column, only: [:show, :edit, :update, :destroy]

    # GET /columns
    def index
      @columns = @view.columns
    end

    # GET /columns/1
    def show
    end

    # GET /columns/new
    def new
      @column = @view.columns.new
    end

    # GET /columns/1/edit
    def edit
    end

    # POST /columns
    def create
      @column = @view.columns.new(column_params)

      if @column.save
        redirect_to view_columns_path(@column.view, @column), notice: 'Column was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /columns/1
    def update
      if @column.update(column_params)
        redirect_to view_columns_path @column.view, notice: 'Column was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /columns/1
    def destroy
      @column.destroy
      redirect_to view_columns_url(@column.view), notice: 'Column was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_column
        @column = Column.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def column_params
        params.require(:column).permit(:method, :prefix, :postfix)
      end
  end
end
