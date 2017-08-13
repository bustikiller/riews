require_dependency "riews/application_controller"

module Riews
  class FilterCriteriasController < ApplicationController
    load_and_authorize_resource :view
    before_action :set_filter_criteria, only: [:show, :edit, :update, :destroy]

    def index
      @filter_criterias = @view.filter_criterias
    end

    def show
    end

    def new
      @filter_criteria = @view.filter_criterias.new
    end

    def edit
      @filter_criteria.arguments.build
    end

    def create
      @filter_criteria = @view.filter_criterias.new(filter_criteria_params)

      if @filter_criteria.save
        redirect_to view_filters_url(@filter_criteria.view), notice: 'Filter was successfully created.'
      else
        render :new
      end
    end

    def update
      if @filter_criteria.update(filter_criteria_params)
        redirect_to view_filters_url(@filter_criteria.view), notice: 'Filter was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @filter_criteria.destroy
      redirect_to view_filters_url(@filter_criteria.view), notice: 'Filter was successfully destroyed.'
    end

    private
    def set_filter_criteria
      @filter_criteria = FilterCriteria.find(params[:id])
    end

    def filter_criteria_params
      params.require(:filter_criteria).permit(:field_name, :operator, :negation,
                                              arguments_attributes: [:value, :id, :_destroy])
    end
  end
end
