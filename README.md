> [!WARNING]
> **This repository is no longer maintained by our internal teams.**  
> The template is provided *as is* and will not receive updates, bug fixes, or new features.  
> You are welcome to contribute on it or fork the repository and modify it for your own use.
> To deploy this template on [Upsun](https://www.upsun.com), you can use the command [upsun project:convert](https://docs.upsun.com/administration/cli/reference.html#projectconvert)
> on this codebase to convert the existing `.platform.app.yaml` configuration file to the [Upsun Flex format](https://docs.upsun.com/create-apps/app-reference/single-runtime-image.html).

# Mattermost for Platform.sh

This template builds Mattermost on Platform.sh, configuring the deployment through user-defined environment variables.  The Mattermost binary is downloaded on the fly during the build step.  It includes a PostgreSQL database and Elasticsearch for indexing, both of which come pre-configured.

Mattermost is an open-source messaging framework written in Go and React.

## Features

* Go 1.19
* PostgreSQL 12
* Elasticsearch 7.2

## Post-install

When Mattermost has been deployed, you can complete the installation by creating your first admin user through the site itself.

## Customizations

The following changes have been made relative from initializing a Mattermost project from its upstream binaries. If using this project as a reference for your own existing project, replicate the changes below to your project.

* The `.platform.app.yaml`, `.platform/services.yaml`, and `.platform/routes.yaml` files have been added.  These provide Platform.sh-specific configuration and are present in all projects on Platform.sh.  You may customize them as you see fit.
* Mattermost binaries are downloaded during the build hook in `setup.sh`. You can edit that file to download a newer version of the upstream on a new environment to update.
* Environment variables are set in `.environment` that override the settings generated in Mattermost's `app/config/config.json` file. Most of these additions connect Mattermost to the PostgreSQL and Elasticsearch services. You can add to this file to override additional variables in `/app/config/config.json` by matching its keys to an exported variable prefixed by `MM_`, and with each key level separated by an underscore. For example, `port` is defined in `config.json` at `ServiceSettings.ListenAddress`, and over-written in `.environment` to read Platform.sh's `PORT` environment variable with `export MM_SERVICESETTINGS_LISTENADDRESS=":$PORT"`.
* **Marketplace Plugins:** To install plugins for Mattermost, navigate to the Plugin Marketplace link in your primary dropdown. The template has already been configured to search the Marketplace, and install plugins to the `client/plugins` mount. Once they are installed, the plugin will still need to be enabled according to its documentation.
* **Non-Marketplace Plugins:** If you would like to install a plugin that is not in the Marketplace, you can visit `System Console > Plugin Management`, and upload a release `.tar.gz` under the `Upload Plugin:` section. Once it has been uploaded, enable it according the the plugin's documentation.

## References

* [Mattermost](https://mattermost.com/)
* [GitHub upstream](https://github.com/mattermost/mattermost-server)
* [Mattermost documentation](https://docs.mattermost.com/)
* [Go on Platform.sh](https://docs.platform.sh/languages/go.html)
