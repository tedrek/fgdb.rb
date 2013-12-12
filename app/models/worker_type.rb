class WorkerType < ActiveRecord::Base
  has_many :workers, :through => WorkersWorkerType
end
