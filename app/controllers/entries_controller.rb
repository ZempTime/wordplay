class EntriesController < ApplicationController
#before_action here
  def index
    @entries = Entry.all
    @entry = Entry.new
  end

  def create
    @entry = Entry.new entry_params

    if @entry.save!
      redirect_to root_path, notice: "The story continues..."
    else
      redirect_to root_path, notice: "Your additiont to the story didn't make it :(" 
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:sentence)
  end
end
