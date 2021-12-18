job "web" {
  namespace = "james-hu"
  datacenters = ["dc1"]

  group "web" {
    count = 1

    network {
      port "http"{
        to = 80
      }
    }

    service {
      # Needs to be unique within Traefik
      name = "james-hu-web"

      port = "http"

      tags = [
        "traefik.enable=true",

        # Only james.hu or www.james.hu will route here
        "traefik.http.routers.james-hu-web.rule=Host(`james.hu`, `www.james.hu`)",

        # Even though entrypoint is https, traffic comes in as plain http
        "traefik.http.routers.james-hu-web.entrypoints=https",

        "traefik.http.routers.james-hu-web.tls=true",
        "traefik.http.routers.james-hu-web.tls.certresolver=letsencrypt",
      ]

      # check {
      #   type     = "http"
      #   path     = "/"
      #   interval = "30s"
      #   timeout  = "10s"
      # }
    }

    task "server" {
      driver = "docker"

      config {
        image = "nginx:1.21.3"
        ports = ["http"]

        volumes = [
          "local/nginx.conf:/etc/nginx/nginx.conf",
          "local/index.html:/srv/index.html",
        ]
      }

      template {
        data = <<-EOF
          events {
            worker_connections 128;
          }

          http {
            # server {
            #   server_name www.james.hu;

            #   return 301 https://james.hu$request_uri;
            # }

            server {
              listen 80;
              # server_name james.hu;

              location / {
                root /srv;
                index index.html;
              }

              location /meet {
                return 302 https://calendly.com/jameshu/30min;
              }

              location /zoom {
                return 302 https://us02web.zoom.us/j/8894849919;
              }
            }
          }
        EOF

        destination = "local/nginx.conf"
      }

      template {
        data = <<-EOF
          <html>
            <head>
              <title>james.hu</title>
              <meta charset="UTF-8">
              <style>
                #wave {
                  font-size: 150px;
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  height: 100%;
                }
              </style>
            </head>
            <body>
              <div id="wave">👋</div>
            </body>
          </html>
        EOF

        destination = "local/index.html"
      }
    }
  }
}
