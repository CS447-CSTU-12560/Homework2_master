from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):

	@task
	def get_something(self):
		self.client.get("/")

class WebsiteUser(HttpLocust):
	task_set = UserBehavior