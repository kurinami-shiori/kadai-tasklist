class TasksController < ApplicationController
    
    before_action :require_user_logged_in, except: [:index]
    before_action :correct_user, only: [:show, :edit, :destroy]
    
    def index
        if logged_in?
            #@task = current_user.tasks.build
            @tasks = current_user.tasks.order(id: :desc).page(params[:page])
        # このふたつあんまよくわかってへん
        end
    end
    
    def show
    end
    
    def new
        @task = current_user.tasks.build #task_params
        #Task.newでもいい。フロントの@taskにつなぐ
    end
    
    def create
        @task = current_user.tasks.build(task_params)
        if @task.save
            flash[:success] = 'タスクが正常に作成されました'
            redirect_to @task
        else    flash.now[:danger] = 'タスクが作成されませんでした'
                render :new
        end
    end
    
    def edit
    end
    
    def update
        if @task.update(task_params)
            redirect_to @task
        else
            render :edit
        end
    end
    
    def destroy
        @task.destroy
        redirect_to tasks_url
    end
    
    private
    
    def task_params
        params.require(:task).permit(:content, :status)
    end
    
    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        unless @task
            redirect_to root_url
        end
    end
end