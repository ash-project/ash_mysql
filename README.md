![Logo](https://github.com/ash-project/ash/blob/main/logos/cropped-for-header-black-text.png?raw=true#gh-light-mode-only)
![Logo](https://github.com/ash-project/ash/blob/main/logos/cropped-for-header-white-text.png?raw=true#gh-dark-mojde-only)

[![CI](https://github.com/ash-project/ash_mysql/actions/workflows/elixir.yml/badge.svg)](https://github.com/ash-project/ash_mysql/actions/workflows/elixir.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Hex version badge](https://img.shields.io/hexpm/v/ash_mysql.svg)](https://hex.pm/packages/ash_mysql)
[![Hexdocs badge](https://img.shields.io/badge/docs-hexdocs-purple)](https://hexdocs.pm/ash_mysql)

# AshMysql

Welcome! `AshMysql` is a MySQL data layer for [Ash Framework](https://hexdocs.pm/ash)
that is derived from [`AshSqlite`](https://hex.pm/packages/ash_sqlite)

## Idiosyncrasies and Warnings

- AshMysql is at a very alpha stage of development: expect bugs and problem!
- It is currently developped with MySQL 8.0. Several changes are still known to be required to work correctly on other versions (particularly regarding collations).
- For now, you should probably have a uuid_primary_key in your resources. Things may crash or be buggy if you don't.
- AshMysql uses the Ecto `:string` (=> MySQL VARCHAR(255)) type (Unlike AshPostgres and AshSqlite) when generating migrations for Ash String fields. The `:text` Ecto type (=> MySQL `TEXT`) is not used by default because of various MySQL peculiarities. Use the `migration_types` option of your `mysql` DSL block if you want `:text` fields. See https://github.com/ash-project/ash_mysql/issues/25 for discussion on the subject.
- If you want case sensitive / insensitive comparisons to work correctly (i.e. in a strict way; not like MySQL's defaults) you currently must use the recommended `utf8mb4_0900_as_cs` collation in your config and when creating your db/tables.

## Tutorials

- [Get Started](documentation/tutorials/getting-started-with-ash-mysql.md)

## Topics

- [What is AshMysql?](documentation/topics/about-ash-mysql/what-is-ash-mysql.md)

### Resources

- [References](documentation/topics/resources/references.md)
- [Polymorphic Resources](documentation/topics/resources/polymorphic-resources.md)

### Development

- [Migrations and tasks](documentation/topics/development/migrations-and-tasks.md)
- [Testing](documentation/topics/development/testing.md)

### Advanced

- [Expressions](documentation/topics/advanced/expressions.md)
- [Manual Relationships](documentation/topics/advanced/manual-relationships.md)

## Reference

- [AshMysql.DataLayer DSL](documentation/dsls/DSL-AshMysql.DataLayer.md)
