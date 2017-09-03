require_dependency "riews/application_controller"

module Riews
  class ViewsController < ApplicationController
    before_action :set_view, only: [:show, :edit, :update, :destroy]

    # GET /views
    def index
      @views = View.all.includes(:relationships)
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
      argument_attributes = [:value, :id, :_destroy]
      action_link_attributes = [:id, :_destroy, :base_path, :display_pattern, :http_verb, arguments_attributes: argument_attributes]
      filter_criteria_attributes = [:field_name, :operator, :negation, :id, :_destroy,
                                    arguments_attributes: argument_attributes]
      column_attributes = [:id, :_destroy, :method, :prefix, :postfix, :aggregate, :name, :pattern, :hide_from_display,
                           :position, action_links_attributes: action_link_attributes]
      relationship_attributes = [:id, :_destroy, :name]
      params.require(:view).permit(:name, :model, :code, :uniqueness, :paginator_size,
                                   columns_attributes: column_attributes,
                                   relationships_attributes: relationship_attributes,
                                   filter_criterias_attributes: filter_criteria_attributes)
    end
  end
end
