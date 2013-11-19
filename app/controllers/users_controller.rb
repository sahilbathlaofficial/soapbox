class UsersController < ApplicationController

  before_filter :set_user, :except => [:autocomplete, :tag_list]

  def show
    if(current_user.company_id != @user.company_id)
      flash[:notice] = 'User doesn\'t exist'
      redirect_to root_path
    end
  end


  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User #{@user.firstname} was successfully updated." }
      else
        format.html { render action: 'edit' }
      end

    end
  end

  def destroy
    if(current_user.priviledged?(@user))
      if(@user.destroy)
        respond_to do |format|
          format.html { redirect_to root_path, notice: 'User destroyed' }
        end
      end
    end
  end

  def wall
    users = current_user.followees + [current_user]
    groups = current_user.groups 
    # CR_Priyank: Move this query to a scope
    # [Fixed] - Added extract_posts scope in post model
    @posts = Post.extract_posts(users, groups)
  end

  def followees
    @followees = @user.followees
  end

  def followers
    @followers = @user.followers
  end

  def autocomplete
    # CR_Priyank: Should be in company's scope
    #[Discuss]
    # CR_Priyank: Move query in model scope
    @users = User.where('(LOWER(firstname) like ? OR LOWER(lastname) like ?) AND company_id = ? ', params[:query].downcase, params[:query].downcase, current_user.company_id).limit(5).pluck('id', 'firstname','lastname', 'avatar_file_name')
    @users += Group.where('(LOWER(name) like ?) AND company_id = ?', params[:query].downcase, current_user.company_id).limit(5).pluck('id', 'name');
    respond_to do |format|
      format.json { render json: @users }
    end
  end

  def tag_list
    users = current_user.followers + current_user.followees + [current_user] 
    @users = User.where('(CONCAT(LOWER(firstname), " ", LOWER(lastname)) like ?) AND id in (?)',  params[:query].downcase, users).limit(5)
    respond_to do |format|
      format.js {}
    end
  end

  protected


  def set_user
    # CR_Priyank: I think we do not need to check if params[:id]
    # [Discuss]
    if(params[:id])
      @user = User.find_by(id: params[:id])
      redirect_to_back_or_default_url if(@user.nil?)
    else
      redirect_to(wall_user_path(current_user))
    end
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :avatar)
  end


end