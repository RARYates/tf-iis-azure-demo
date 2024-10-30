module "a" {
  source = "./modules/a"
  prefix = "thing"
  region = "thing"
}

module "b" {
  source = "./modules/b"
}

module "c" {
  source = "./modules/c"
}

