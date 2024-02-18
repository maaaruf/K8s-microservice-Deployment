tf_init:
	@ echo "Initializing terraform...."
	@ cd env/dev
	@ ls
	@ terraform fmt -recursive
	@ terraform init

tf_plan:
	@ echo "Planning terraform..."
	@ cd env/dev
	@ terraform plan

tf_apply:
	@ echo "Applying terraform..."
	@ cd env/dev
	@ terraform apply -auto-approve

tf_destroy:
	@ echo "Destroying terraform..."
	@ cd env/dev
	@ terraform destroy -auto-approve