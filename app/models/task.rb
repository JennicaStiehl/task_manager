require 'sqlite3'

class Task
  attr_reader :title, :description, :id, :priority, :due_date

  def initialize(task_params)
    @database = SQLite3::Database.new('db/task_manager_development.db')
    @database.results_as_hash = true
    @id = task_params["id"] if task_params["id"]
    @description = task_params["description"]
    @title       = task_params["title"]
    @priority    = task_params["priority"]
    @due_date    = task_params["due_date"]
  end

  def save
  @database.execute("INSERT INTO tasks (title, description, priority, due_date) VALUES (?, ?, ?, >);", @title, @description, @priority, @due_date)
  end

  def self.database
    database = SQLite3::Database.new('db/task_manager_development.db')
    database.results_as_hash = true
    database
  end

  def self.all
    tasks = database.execute("SELECT * FROM tasks ORDER BY due_date, priority asc")
    tasks.map do |task|
      Task.new(task)
    end
  end

  def self.find(id)
    task = database.execute("SELECT * FROM tasks WHERE id = ?", id.to_i).first
    Task.new(task)
  end

  def self.update(id, task_params)
    database.execute("UPDATE tasks
                SET title = ?,
                    description = ?,
                    priority = ?,
                    due_date = ?
                WHERE id = ?;",
                task_params[:title],
                task_params[:description],
                task_params[:priority],
                task_params[:due_date],
                id)

    Task.find(id)
  end

  def self.destroy(id)
    database.execute("DELETE FROM tasks
                      WHERE id = ?;", id)
  end

end
