ActiveAdmin.register Task do

  scope :all, :default => true
  scope :due_this_week do |tasks|
    tasks.where('due_date > ? and due_date < ?', Time.now, 1.week.from_now)
  end
  scope :late do |tasks|
    tasks.where('due_date < ?', Time.now)
  end
  scope :mine do |tasks|
    tasks.where(:admin_user_id => current_admin_user.id)
  end


  index :download_links => false do
    column :title
    column  "Status", :sortable => :is_done do |task|
       status_tag (task.is_done ? "Done" : "Pending"), (task.is_done ? :ok : :error)     end
    default_actions
  end

  #filters

  filter:project_id
  filter:admin_user_id
  filter:due_date


  form do |f|
      f.inputs "Task Details" do
        f.input :project_id, :as => :select, :collection => Project.all
        f.input :admin_user_id, :as => :select, :collection => AdminUser.all
        f.input :title
        f.input :is_done
        f.input :due_date

      end
      f.actions
    end



  show do
    panel "Task Details" do
      attributes_table_for task do
        row("Status") { status_tag (task.is_done ? "Done" : "Pending"), (task.is_done ? :ok : :error) }
        row("Title") { task.title }
        row("Project") { link_to task.project.title, admin_project_path(task.project) }
        row("Assigned To") { link_to task.admin_user.email, admin_admin_user_path(task.admin_user) }
        row("Due Date") { task.due_date? ? l(task.due_date, :format => :long) : '-' }
      end
    end
    active_admin_comments
  end

  sidebar "Other Tasks For This User", :only => :show do
    table_for current_admin_user.tasks.where(:project_id => task.project) do |t|
      t.column("Status") { |task| status_tag (task.is_done ? "Done" : "Pending"), (task.is_done ? :ok : :error) }
      t.column("Title") { |task| link_to task.title, admin_task_path(task) }
    end
  end
  
end
