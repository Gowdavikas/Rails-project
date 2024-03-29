class UsersController < ActionController::Base
    ROLES = { company: "company", jobseeker: "jobseeker", freelancer: "freelancer" }
    def index
        users = User.all
        if users.empty?
            render json: {
                message: "Users Not Found",
                users: []
            }, status: :not_found
        else
            render json: {
                message: "Users Found",
                users: users.as_json(only: [:id, :name, :role])
            }, status: :ok
        end
    end

    def show
        user = set_user
        if user
            render json: {
                message: "User Found",
                user: user.as_json(only: [:id, :name, :role])
            }, status: :ok
        else
            render json: {
                message: "User Not Found",
                user: []
            }, status: :not_found
        end
    end
    
    def create
        user = User.create(user_params)
        if user.save
            render json: {
                message: "User Created Successfully",
                user: user.as_json(only: [:id, :name, :role])
            }, status: :created
        else
            render json: {
                message: " User Unable To Create",
                error: user.errors.full_messages
            }, status: 422
        end
    end

    def update
        user = set_user
        if user.update(user_params)
            render json: {
                message: "User Updated Successfully",
                user: user.as_json(only: [:id, :name, :role])
            }, status: :ok
        else
            render json: {
                message: "User Unable to Upadte",
                error: user.errors.full_messages
            }, status: 422
        end
    end

    def destroy
        user = set_user
        if user.delete
            render json: {
                message: "User Deleted Successfully",
                user: user.as_json(only: [:id, :name, :role])
            }, status: :ok
        else
            render json: {
                message: "User unable to Delete",
                error: user.errors.full_messages 
            }, status: 422
        end
    end

    def get_roles
        render json: {
            message: "Roles Found",
            roles: ROLES
        }, status: :ok
    end

    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :role,:token)
    end

    def set_user
        jwt_payload = JWT.decode(request.headers['token'], ENV['secret_key_base']).first
        @current_user = User.find(jwt_payload['sub'])
        user = User.find(@current_user.id)
        if user
            return user
        end
    end
end
