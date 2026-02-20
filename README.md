> [!NOTE]
> **This is a community-maintained deployment template, not an official Upsun-supported project.**
> The template used in this article is a community-maintained deployment template, not an official Upsun-supported project.
> It is provided *as is* and may not receive timely updates, bug fixes, or new features.
> You are welcome to contribute or fork the repository and modify it for your own use.

# Mattermost Team Edition for Upsun (Community Fork)

This template deploys **Mattermost Team Edition** on [Upsun](https://www.upsun.com), configuring the deployment through user-defined environment variables. The Mattermost Team Edition binary is downloaded on the fly during the build step. It includes a PostgreSQL database and OpenSearch for full-text indexing, both of which come pre-configured.

Mattermost is an open-source messaging platform written in Go and React. The **Team Edition** is the free, self-hosted version of Mattermost, suitable for teams that want full control over their messaging infrastructure without a license fee.

> **Note:** This template uses Mattermost **Team Edition** (free, open-source). It does not include Enterprise Edition features such as AD/LDAP, SAML SSO, advanced compliance, or guest accounts.

## Features

* Mattermost 11.4.0 Team Edition
* Go 1.22
* PostgreSQL 16
* OpenSearch 2

## Post-install

When Mattermost has been deployed, you can complete the installation by creating your first admin user through the site itself.

## Customizations

The following changes have been made relative to the original Platform.sh template. This fork converts the configuration to Upsun format and upgrades all services. If using this project as a reference for your own existing project, replicate the changes below.

* The `.upsun/config.yaml` file provides Upsun-specific configuration for the app, services (PostgreSQL, OpenSearch), and routes.
* Mattermost Team Edition binaries are downloaded during the build hook in `build.sh`. You can edit that file to download a newer version of the upstream on a new environment to update.
* Environment variables are set in `.environment` that override the settings generated in Mattermost's `app/config/config.json` file. Most of these additions connect Mattermost to the PostgreSQL and OpenSearch services. You can add to this file to override additional variables in `/app/config/config.json` by matching its keys to an exported variable prefixed by `MM_`, and with each key level separated by an underscore. For example, `port` is defined in `config.json` at `ServiceSettings.ListenAddress`, and over-written in `.environment` to read Upsun's `PORT` environment variable with `export MM_SERVICESETTINGS_LISTENADDRESS=":$PORT"`.
* **Marketplace Plugins:** To install plugins for Mattermost, navigate to the Plugin Marketplace link in your primary dropdown. The template has already been configured to search the Marketplace, and install plugins to the `client/plugins` mount. Once they are installed, the plugin will still need to be enabled according to its documentation.
* **Non-Marketplace Plugins:** If you would like to install a plugin that is not in the Marketplace, you can visit `System Console > Plugin Management`, and upload a release `.tar.gz` under the `Upload Plugin:` section. Once it has been uploaded, enable it according to the plugin's documentation.

## References

* [Mattermost](https://mattermost.com/)
* [Mattermost Team Edition](https://mattermost.com/mattermost-team-edition/)
* [GitHub upstream](https://github.com/mattermost/mattermost-server)
* [Mattermost documentation](https://docs.mattermost.com/)
* [Upsun documentation](https://docs.upsun.com/)
