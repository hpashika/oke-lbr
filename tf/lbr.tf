resource "oci_load_balancer" "lbr" {
  shape          = "100Mbps"
  compartment_id = var.compartment_id
  subnet_ids     = [var.subnet_id]
  display_name   = var.lbr_display_name
}

resource "oci_load_balancer_backendset" "red" {
  name             = "red_backend_set"
  load_balancer_id = oci_load_balancer.lbr.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port        = var.red_node_port
    protocol    = "HTTP"
    return_code = "200"
    url_path    = "/red/index.html"
  }
}

resource "oci_load_balancer_backend" "red_backends" {
  count            = length(var.nodes)
  load_balancer_id = oci_load_balancer.lbr.id
  backendset_name  = oci_load_balancer_backendset.red.name
  ip_address       = element(var.nodes, count.index)
  port             = var.red_node_port
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}


resource "oci_load_balancer_backendset" "green" {
  name             = "green_backend_set"
  load_balancer_id = oci_load_balancer.lbr.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port        = var.green_node_port
    protocol    = "HTTP"
    return_code = "200"
    url_path    = "/green/index.html"
  }
}

resource "oci_load_balancer_backend" "green_backends" {
  count            = length(var.nodes)
  load_balancer_id = oci_load_balancer.lbr.id
  backendset_name  = oci_load_balancer_backendset.green.name
  ip_address       = element(var.nodes, count.index)
  port             = var.green_node_port
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_path_route_set" "shared_path_route_set" {
  #Required
  load_balancer_id = oci_load_balancer.lbr.id
  name             = "shared_lbr_paths"

  path_routes {
    #Required
    backend_set_name = oci_load_balancer_backendset.red.name
    path             = "/red"

    path_match_type {
      #Required
      match_type = "PREFIX_MATCH"
    }
  }

  path_routes {
    #Required
    backend_set_name = oci_load_balancer_backendset.green.name
    path             = "/green"

    path_match_type {
      #Required
      match_type = "PREFIX_MATCH"
    }
  }
}

resource "oci_load_balancer_listener" "lbr_listener" {
  load_balancer_id         = oci_load_balancer.lbr.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backendset.red.name
  port                     = 80
  protocol                 = "HTTP"
  path_route_set_name      = oci_load_balancer_path_route_set.shared_path_route_set.name
  connection_configuration {
    idle_timeout_in_seconds  = "180"
  }
}
