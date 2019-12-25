class BookCommentsController < ApplicationController
   def create
        book = Book.find(params[:book_id])
        book_comment = current_user.book_comments.new(post_comment_params)
        book_comment.book_id = book.id
        book_comment.save
        redirect_to book_path(book)
    end
    def destroy
        book = Book.find(params[:book_id])
        book_comment = BookComment.find(params[:id])
        book_comment.destroy
        redirect_to book_path(book)
    end

    private
	def post_comment_params
	    params.require(:book_comment).permit(:user_id,:book_id,:comment)
	end
end