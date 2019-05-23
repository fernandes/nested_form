class AlbumsController < ApplicationController
  def index
    run Albums::Operation::Index
    trbrender Albums::Cell::Index, @model
  end

  def new
    run Albums::Operation::Create::Present
    trbrender Albums::Cell::New, @form
  end

  def create
    run Albums::Operation::Create do |result|
      flash[:notice] = "album has been created"
      return redirect_to album_path(result['model'].id)
    end

    opts = { status: :unprocessable_entity }
    trbrender Albums::Cell::New, @form, rails_options: opts
  end

  def show
    run Albums::Operation::Show
    trbrender Albums::Cell::Show, @model
  end

  def edit
    run Albums::Operation::Update::Present
    trbrender Albums::Cell::Edit, @form
  end

  def update
    run Albums::Operation::Update do |result|
      flash[:notice] = "album has been updated"
      return redirect_to album_path(result["model"].id)
    end

    opts = { status: :unprocessable_entity }
    trbrender Albums::Cell::Edit, @form, rails_options: opts
  end

  def destroy
    run Albums::Operation::Destroy do |op|
      respond_to do |format|
        flash.notice = "album has been removed"
        format.js { redirect_to albums_url }
        format.html { redirect_to albums_url }
      end
    end
  end

  private
    def trbrender(cell_constant, model, options: {}, rails_options: {})
      render(
        {
          html: cell(
            cell_constant,
            model,
            {
              layout: Theme::Cell::Layout,
              context: { current_user: current_user, flash: flash, controller: self },
              result: @_result
            }.merge(options)
          )
        }.merge(rails_options)
      )
    end
end
