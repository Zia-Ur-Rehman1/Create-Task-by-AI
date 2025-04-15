class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user
    if @task.save
      # Send a Slack Notification using external service.
      # Service Setting:
      # Minimum Instance: Zero
      # Timeout: 3 seconds
      HTTParty.post(
        "https://us-central1-piktochart-info.cloudfunctions.net/taskNotifications",
        body: {
          task_id: @task.id,
          message: "Task '#{@task.title}' created!"
        }
      )
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def complete
    @task = Task.find(params[:id])
    # Send a Slack Notification using external service.
    # Service Setting:
    # Minimum Instance: Zero
    # Timeout: 3 seconds
    HTTParty.post(
      "https://us-central1-piktochart-info.cloudfunctions.net/taskNotifications",
      body: {
        task_id: @task.id,
        message: "Task '#{@task.title}' completed!"
      }
    )
    @task.update(completed: true)
    redirect_to @task, notice: 'Task completed!'
  end

  def publish
    @task = Task.find(params[:id])
    # Send a Slack Notification using external service.
    # Service Setting:
    # Minimum Instance: Zero
    # Timeout: 3 seconds
    HTTParty.post(
      "https://us-central1-piktochart-info.cloudfunctions.net/taskNotifications",
      body: {
        task_id: @task.id,
        message: "Task '#{@task.title}' published!"
      }
    )
    @task.update(published: true)
    redirect_to @task, notice: 'Task completed!'
  end

  def search
    @tasks = Task.where("title LIKE '%#{params[:query]}%'")
    render :index
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
