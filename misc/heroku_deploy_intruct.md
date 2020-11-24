# Deploying on Heroku

More information for [deploying Julia projects on Heroku.com](https://towardsdatascience.com/deploying-julia-projects-on-heroku-com-eb8da5248134)


Required
- app files
- Heroku account
  - *free*
- julia
- heroku cli
  - sudo snap install --classic heroku

Now enter your app directory and run Julia
> λ  cd myapp\
> λ  julia

You need to create a new project with `Project.toml` and `Manifest.toml` files
containing the information of the versions of packages and registries you will
need to use.  The following code activates your new environment with the 2 files
and adds the packages you will need for you app, which then stores the information
in the 2 files.
> λ  using Pkg; Pkg.activate(".")\
> λ  Pkg.add("Dash") # Do this as many times as needed\
> ...

You may now close your terminal window.

We'll now create a `Procfile`, which is a blank file that Heroku uses to
instruct the deployment of your files. You will need to create the file called
`Procfile` and copy and paste the following line of code into the file.
> web: julia --project app.jl $PORT

You will need to replace `app.jl` with the filename of the starting file of your
application. Then, you may save the file into your directory where your app will be.

Now, your directory should have your
- app files
- Project.toml
- Manifest.toml
- Procfile

As you normally host your Dashboards app on a port on localhost, you will need
to replace your host method and number because Heroku deploys the application
on a random port.

After that is done, you can open up a new window on your cmd or Terminal and log
into your Heroku CLI account by typing:

> λ  heroku login

It should open up a browser window for you to enter your credentials.  You will
find yourself logged in after you are done logging in and closing the browser
window. Now, you can enter your directory once again and deploy your app.

Please replace `my-app-name` with the name you would like to call your app in
the following code!

> λ  cd myapp\
> λ  git init\
> λ  HEROKU_APP_NAME=my-app-name\
> λ  heroku create $HEROKU_APP_NAME --buildpack https://github.com/Optomatica/heroku-buildpack-julia.git \
> λ  heroku git:remote -a $HEROKU_APP_NAME\
> λ  git add .\
> λ  git commit -am "make it better"\
> λ  git push heroku master\

Once the process is completed, the application will be deployed and live!

It should take a while, but once you are finished, you can run the following to open your deployed app on a browser!

> λ  heroku open -a $HEROKU_APP_NAME

To restart use:
> λ  heroku restart

To check your logs use:
> λ  heroku logs --tail

I found more useful troubleshooting information [here](https://dev.to/lawrence_eagles/causes-of-heroku-h10-app-crashed-error-and-how-to-solve-them-3jnl).
