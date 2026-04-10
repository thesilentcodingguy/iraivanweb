class CommentsController < ApplicationController
  before_action :set_recipe

  def create
    @comment = @recipe.comments.build(comment_params)

    if @comment.save
      redirect_to @recipe, notice: "Comment added"
    else
      redirect_to @recipe, alert: "Error adding comment"
    end
  end

  def destroy
    @comment = @recipe.comments.find(params[:id])
    @comment.destroy
    redirect_to @recipe
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def comment_params
    params.require(:comment).permit(:title, :user_id)
  end
end
