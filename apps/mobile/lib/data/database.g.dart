// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMainMeta = const VerificationMeta(
    'colorMain',
  );
  @override
  late final GeneratedColumn<String> colorMain = GeneratedColumn<String>(
    'color_main',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorSecondaryMeta = const VerificationMeta(
    'colorSecondary',
  );
  @override
  late final GeneratedColumn<String> colorSecondary = GeneratedColumn<String>(
    'color_secondary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationsJsonMeta = const VerificationMeta(
    'translationsJson',
  );
  @override
  late final GeneratedColumn<String> translationsJson = GeneratedColumn<String>(
    'translations_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    name,
    description,
    icon,
    colorMain,
    colorSecondary,
    sortOrder,
    translationsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color_main')) {
      context.handle(
        _colorMainMeta,
        colorMain.isAcceptableOrUnknown(data['color_main']!, _colorMainMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMainMeta);
    }
    if (data.containsKey('color_secondary')) {
      context.handle(
        _colorSecondaryMeta,
        colorSecondary.isAcceptableOrUnknown(
          data['color_secondary']!,
          _colorSecondaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_colorSecondaryMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('translations_json')) {
      context.handle(
        _translationsJsonMeta,
        translationsJson.isAcceptableOrUnknown(
          data['translations_json']!,
          _translationsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      colorMain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_main'],
      )!,
      colorSecondary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_secondary'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      translationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translations_json'],
      ),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final String id;
  final String slug;
  final String name;
  final String? description;
  final String? icon;
  final String colorMain;
  final String colorSecondary;
  final int sortOrder;
  final String? translationsJson;
  const Game({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.icon,
    required this.colorMain,
    required this.colorSecondary,
    required this.sortOrder,
    this.translationsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['slug'] = Variable<String>(slug);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['color_main'] = Variable<String>(colorMain);
    map['color_secondary'] = Variable<String>(colorSecondary);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || translationsJson != null) {
      map['translations_json'] = Variable<String>(translationsJson);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      slug: Value(slug),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      colorMain: Value(colorMain),
      colorSecondary: Value(colorSecondary),
      sortOrder: Value(sortOrder),
      translationsJson: translationsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(translationsJson),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<String>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      colorMain: serializer.fromJson<String>(json['colorMain']),
      colorSecondary: serializer.fromJson<String>(json['colorSecondary']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      translationsJson: serializer.fromJson<String?>(json['translationsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'slug': serializer.toJson<String>(slug),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
      'colorMain': serializer.toJson<String>(colorMain),
      'colorSecondary': serializer.toJson<String>(colorSecondary),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'translationsJson': serializer.toJson<String?>(translationsJson),
    };
  }

  Game copyWith({
    String? id,
    String? slug,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    String? colorMain,
    String? colorSecondary,
    int? sortOrder,
    Value<String?> translationsJson = const Value.absent(),
  }) => Game(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    icon: icon.present ? icon.value : this.icon,
    colorMain: colorMain ?? this.colorMain,
    colorSecondary: colorSecondary ?? this.colorSecondary,
    sortOrder: sortOrder ?? this.sortOrder,
    translationsJson: translationsJson.present
        ? translationsJson.value
        : this.translationsJson,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorMain: data.colorMain.present ? data.colorMain.value : this.colorMain,
      colorSecondary: data.colorSecondary.present
          ? data.colorSecondary.value
          : this.colorSecondary,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      translationsJson: data.translationsJson.present
          ? data.translationsJson.value
          : this.translationsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('colorMain: $colorMain, ')
          ..write('colorSecondary: $colorSecondary, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('translationsJson: $translationsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    slug,
    name,
    description,
    icon,
    colorMain,
    colorSecondary,
    sortOrder,
    translationsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.colorMain == this.colorMain &&
          other.colorSecondary == this.colorSecondary &&
          other.sortOrder == this.sortOrder &&
          other.translationsJson == this.translationsJson);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<String> id;
  final Value<String> slug;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<String> colorMain;
  final Value<String> colorSecondary;
  final Value<int> sortOrder;
  final Value<String?> translationsJson;
  final Value<int> rowid;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorMain = const Value.absent(),
    this.colorSecondary = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCompanion.insert({
    required String id,
    required String slug,
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    required String colorMain,
    required String colorSecondary,
    required int sortOrder,
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       slug = Value(slug),
       name = Value(name),
       colorMain = Value(colorMain),
       colorSecondary = Value(colorSecondary),
       sortOrder = Value(sortOrder);
  static Insertable<Game> custom({
    Expression<String>? id,
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<String>? colorMain,
    Expression<String>? colorSecondary,
    Expression<int>? sortOrder,
    Expression<String>? translationsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (colorMain != null) 'color_main': colorMain,
      if (colorSecondary != null) 'color_secondary': colorSecondary,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (translationsJson != null) 'translations_json': translationsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCompanion copyWith({
    Value<String>? id,
    Value<String>? slug,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? icon,
    Value<String>? colorMain,
    Value<String>? colorSecondary,
    Value<int>? sortOrder,
    Value<String?>? translationsJson,
    Value<int>? rowid,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      colorMain: colorMain ?? this.colorMain,
      colorSecondary: colorSecondary ?? this.colorSecondary,
      sortOrder: sortOrder ?? this.sortOrder,
      translationsJson: translationsJson ?? this.translationsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorMain.present) {
      map['color_main'] = Variable<String>(colorMain.value);
    }
    if (colorSecondary.present) {
      map['color_secondary'] = Variable<String>(colorSecondary.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (translationsJson.present) {
      map['translations_json'] = Variable<String>(translationsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('colorMain: $colorMain, ')
          ..write('colorSecondary: $colorSecondary, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('translationsJson: $translationsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('free'),
  );
  static const VerificationMeta _translationsJsonMeta = const VerificationMeta(
    'translationsJson',
  );
  @override
  late final GeneratedColumn<String> translationsJson = GeneratedColumn<String>(
    'translations_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    slug,
    name,
    description,
    icon,
    sortOrder,
    tier,
    translationsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    }
    if (data.containsKey('translations_json')) {
      context.handle(
        _translationsJsonMeta,
        translationsJson.isAcceptableOrUnknown(
          data['translations_json']!,
          _translationsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      tier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier'],
      )!,
      translationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translations_json'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String gameId;
  final String slug;
  final String name;
  final String? description;
  final String? icon;
  final int sortOrder;
  final String tier;
  final String? translationsJson;
  const Category({
    required this.id,
    required this.gameId,
    required this.slug,
    required this.name,
    this.description,
    this.icon,
    required this.sortOrder,
    required this.tier,
    this.translationsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['slug'] = Variable<String>(slug);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['tier'] = Variable<String>(tier);
    if (!nullToAbsent || translationsJson != null) {
      map['translations_json'] = Variable<String>(translationsJson);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      slug: Value(slug),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortOrder: Value(sortOrder),
      tier: Value(tier),
      translationsJson: translationsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(translationsJson),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      slug: serializer.fromJson<String>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      tier: serializer.fromJson<String>(json['tier']),
      translationsJson: serializer.fromJson<String?>(json['translationsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'slug': serializer.toJson<String>(slug),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'tier': serializer.toJson<String>(tier),
      'translationsJson': serializer.toJson<String?>(translationsJson),
    };
  }

  Category copyWith({
    String? id,
    String? gameId,
    String? slug,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    int? sortOrder,
    String? tier,
    Value<String?> translationsJson = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    slug: slug ?? this.slug,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    icon: icon.present ? icon.value : this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    tier: tier ?? this.tier,
    translationsJson: translationsJson.present
        ? translationsJson.value
        : this.translationsJson,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      tier: data.tier.present ? data.tier.value : this.tier,
      translationsJson: data.translationsJson.present
          ? data.translationsJson.value
          : this.translationsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('tier: $tier, ')
          ..write('translationsJson: $translationsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    slug,
    name,
    description,
    icon,
    sortOrder,
    tier,
    translationsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.tier == this.tier &&
          other.translationsJson == this.translationsJson);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> slug;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<int> sortOrder;
  final Value<String> tier;
  final Value<String?> translationsJson;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.tier = const Value.absent(),
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String gameId,
    required String slug,
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    required int sortOrder,
    this.tier = const Value.absent(),
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       slug = Value(slug),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<String>? tier,
    Expression<String>? translationsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (tier != null) 'tier': tier,
      if (translationsJson != null) 'translations_json': translationsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<String>? slug,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? icon,
    Value<int>? sortOrder,
    Value<String>? tier,
    Value<String?>? translationsJson,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      tier: tier ?? this.tier,
      translationsJson: translationsJson ?? this.translationsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (translationsJson.present) {
      map['translations_json'] = Variable<String>(translationsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('tier: $tier, ')
          ..write('translationsJson: $translationsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardsTable extends Cards with TableInfo<$CardsTable, Card> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _text_Meta = const VerificationMeta('text_');
  @override
  late final GeneratedColumn<String> text_ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalTagsJsonMeta = const VerificationMeta(
    'canonicalTagsJson',
  );
  @override
  late final GeneratedColumn<String> canonicalTagsJson =
      GeneratedColumn<String>(
        'canonical_tags_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('free'),
  );
  static const VerificationMeta _translationsJsonMeta = const VerificationMeta(
    'translationsJson',
  );
  @override
  late final GeneratedColumn<String> translationsJson = GeneratedColumn<String>(
    'translations_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    text_,
    intensity,
    tagsJson,
    canonicalTagsJson,
    sortOrder,
    tier,
    translationsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Card> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _text_Meta,
        text_.isAcceptableOrUnknown(data['text']!, _text_Meta),
      );
    } else if (isInserting) {
      context.missing(_text_Meta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_tagsJsonMeta);
    }
    if (data.containsKey('canonical_tags_json')) {
      context.handle(
        _canonicalTagsJsonMeta,
        canonicalTagsJson.isAcceptableOrUnknown(
          data['canonical_tags_json']!,
          _canonicalTagsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalTagsJsonMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    }
    if (data.containsKey('translations_json')) {
      context.handle(
        _translationsJsonMeta,
        translationsJson.isAcceptableOrUnknown(
          data['translations_json']!,
          _translationsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Card map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Card(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      text_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      canonicalTagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_tags_json'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      tier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier'],
      )!,
      translationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translations_json'],
      ),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class Card extends DataClass implements Insertable<Card> {
  final String id;
  final String categoryId;
  final String text_;
  final int intensity;
  final String tagsJson;
  final String canonicalTagsJson;
  final int sortOrder;
  final String tier;
  final String? translationsJson;
  const Card({
    required this.id,
    required this.categoryId,
    required this.text_,
    required this.intensity,
    required this.tagsJson,
    required this.canonicalTagsJson,
    required this.sortOrder,
    required this.tier,
    this.translationsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['text'] = Variable<String>(text_);
    map['intensity'] = Variable<int>(intensity);
    map['tags_json'] = Variable<String>(tagsJson);
    map['canonical_tags_json'] = Variable<String>(canonicalTagsJson);
    map['sort_order'] = Variable<int>(sortOrder);
    map['tier'] = Variable<String>(tier);
    if (!nullToAbsent || translationsJson != null) {
      map['translations_json'] = Variable<String>(translationsJson);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      text_: Value(text_),
      intensity: Value(intensity),
      tagsJson: Value(tagsJson),
      canonicalTagsJson: Value(canonicalTagsJson),
      sortOrder: Value(sortOrder),
      tier: Value(tier),
      translationsJson: translationsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(translationsJson),
    );
  }

  factory Card.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Card(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      text_: serializer.fromJson<String>(json['text_']),
      intensity: serializer.fromJson<int>(json['intensity']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      canonicalTagsJson: serializer.fromJson<String>(json['canonicalTagsJson']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      tier: serializer.fromJson<String>(json['tier']),
      translationsJson: serializer.fromJson<String?>(json['translationsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'text_': serializer.toJson<String>(text_),
      'intensity': serializer.toJson<int>(intensity),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'canonicalTagsJson': serializer.toJson<String>(canonicalTagsJson),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'tier': serializer.toJson<String>(tier),
      'translationsJson': serializer.toJson<String?>(translationsJson),
    };
  }

  Card copyWith({
    String? id,
    String? categoryId,
    String? text_,
    int? intensity,
    String? tagsJson,
    String? canonicalTagsJson,
    int? sortOrder,
    String? tier,
    Value<String?> translationsJson = const Value.absent(),
  }) => Card(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    text_: text_ ?? this.text_,
    intensity: intensity ?? this.intensity,
    tagsJson: tagsJson ?? this.tagsJson,
    canonicalTagsJson: canonicalTagsJson ?? this.canonicalTagsJson,
    sortOrder: sortOrder ?? this.sortOrder,
    tier: tier ?? this.tier,
    translationsJson: translationsJson.present
        ? translationsJson.value
        : this.translationsJson,
  );
  Card copyWithCompanion(CardsCompanion data) {
    return Card(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      text_: data.text_.present ? data.text_.value : this.text_,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      canonicalTagsJson: data.canonicalTagsJson.present
          ? data.canonicalTagsJson.value
          : this.canonicalTagsJson,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      tier: data.tier.present ? data.tier.value : this.tier,
      translationsJson: data.translationsJson.present
          ? data.translationsJson.value
          : this.translationsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Card(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('text_: $text_, ')
          ..write('intensity: $intensity, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('canonicalTagsJson: $canonicalTagsJson, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('tier: $tier, ')
          ..write('translationsJson: $translationsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    text_,
    intensity,
    tagsJson,
    canonicalTagsJson,
    sortOrder,
    tier,
    translationsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Card &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.text_ == this.text_ &&
          other.intensity == this.intensity &&
          other.tagsJson == this.tagsJson &&
          other.canonicalTagsJson == this.canonicalTagsJson &&
          other.sortOrder == this.sortOrder &&
          other.tier == this.tier &&
          other.translationsJson == this.translationsJson);
}

class CardsCompanion extends UpdateCompanion<Card> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> text_;
  final Value<int> intensity;
  final Value<String> tagsJson;
  final Value<String> canonicalTagsJson;
  final Value<int> sortOrder;
  final Value<String> tier;
  final Value<String?> translationsJson;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.text_ = const Value.absent(),
    this.intensity = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.canonicalTagsJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.tier = const Value.absent(),
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required String categoryId,
    required String text_,
    required int intensity,
    required String tagsJson,
    required String canonicalTagsJson,
    required int sortOrder,
    this.tier = const Value.absent(),
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId),
       text_ = Value(text_),
       intensity = Value(intensity),
       tagsJson = Value(tagsJson),
       canonicalTagsJson = Value(canonicalTagsJson),
       sortOrder = Value(sortOrder);
  static Insertable<Card> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? text_,
    Expression<int>? intensity,
    Expression<String>? tagsJson,
    Expression<String>? canonicalTagsJson,
    Expression<int>? sortOrder,
    Expression<String>? tier,
    Expression<String>? translationsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (text_ != null) 'text': text_,
      if (intensity != null) 'intensity': intensity,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (canonicalTagsJson != null) 'canonical_tags_json': canonicalTagsJson,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (tier != null) 'tier': tier,
      if (translationsJson != null) 'translations_json': translationsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String>? text_,
    Value<int>? intensity,
    Value<String>? tagsJson,
    Value<String>? canonicalTagsJson,
    Value<int>? sortOrder,
    Value<String>? tier,
    Value<String?>? translationsJson,
    Value<int>? rowid,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      text_: text_ ?? this.text_,
      intensity: intensity ?? this.intensity,
      tagsJson: tagsJson ?? this.tagsJson,
      canonicalTagsJson: canonicalTagsJson ?? this.canonicalTagsJson,
      sortOrder: sortOrder ?? this.sortOrder,
      tier: tier ?? this.tier,
      translationsJson: translationsJson ?? this.translationsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (text_.present) {
      map['text'] = Variable<String>(text_.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (canonicalTagsJson.present) {
      map['canonical_tags_json'] = Variable<String>(canonicalTagsJson.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (translationsJson.present) {
      map['translations_json'] = Variable<String>(translationsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('text_: $text_, ')
          ..write('intensity: $intensity, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('canonicalTagsJson: $canonicalTagsJson, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('tier: $tier, ')
          ..write('translationsJson: $translationsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RuleSlidesTable extends RuleSlides
    with TableInfo<$RuleSlidesTable, RuleSlide> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuleSlidesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageRefMeta = const VerificationMeta(
    'imageRef',
  );
  @override
  late final GeneratedColumn<String> imageRef = GeneratedColumn<String>(
    'image_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _translationsJsonMeta = const VerificationMeta(
    'translationsJson',
  );
  @override
  late final GeneratedColumn<String> translationsJson = GeneratedColumn<String>(
    'translations_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    sortOrder,
    title,
    content,
    imageRef,
    translationsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rule_slides';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuleSlide> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('image_ref')) {
      context.handle(
        _imageRefMeta,
        imageRef.isAcceptableOrUnknown(data['image_ref']!, _imageRefMeta),
      );
    }
    if (data.containsKey('translations_json')) {
      context.handle(
        _translationsJsonMeta,
        translationsJson.isAcceptableOrUnknown(
          data['translations_json']!,
          _translationsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuleSlide map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuleSlide(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      imageRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_ref'],
      ),
      translationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translations_json'],
      ),
    );
  }

  @override
  $RuleSlidesTable createAlias(String alias) {
    return $RuleSlidesTable(attachedDatabase, alias);
  }
}

class RuleSlide extends DataClass implements Insertable<RuleSlide> {
  final String id;
  final String gameId;
  final int sortOrder;
  final String title;
  final String content;

  /// `asset://{hash}.{ext}` — résolu contre ContentAssets, jamais une URL.
  final String? imageRef;
  final String? translationsJson;
  const RuleSlide({
    required this.id,
    required this.gameId,
    required this.sortOrder,
    required this.title,
    required this.content,
    this.imageRef,
    this.translationsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || imageRef != null) {
      map['image_ref'] = Variable<String>(imageRef);
    }
    if (!nullToAbsent || translationsJson != null) {
      map['translations_json'] = Variable<String>(translationsJson);
    }
    return map;
  }

  RuleSlidesCompanion toCompanion(bool nullToAbsent) {
    return RuleSlidesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      sortOrder: Value(sortOrder),
      title: Value(title),
      content: Value(content),
      imageRef: imageRef == null && nullToAbsent
          ? const Value.absent()
          : Value(imageRef),
      translationsJson: translationsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(translationsJson),
    );
  }

  factory RuleSlide.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuleSlide(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      imageRef: serializer.fromJson<String?>(json['imageRef']),
      translationsJson: serializer.fromJson<String?>(json['translationsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'imageRef': serializer.toJson<String?>(imageRef),
      'translationsJson': serializer.toJson<String?>(translationsJson),
    };
  }

  RuleSlide copyWith({
    String? id,
    String? gameId,
    int? sortOrder,
    String? title,
    String? content,
    Value<String?> imageRef = const Value.absent(),
    Value<String?> translationsJson = const Value.absent(),
  }) => RuleSlide(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    sortOrder: sortOrder ?? this.sortOrder,
    title: title ?? this.title,
    content: content ?? this.content,
    imageRef: imageRef.present ? imageRef.value : this.imageRef,
    translationsJson: translationsJson.present
        ? translationsJson.value
        : this.translationsJson,
  );
  RuleSlide copyWithCompanion(RuleSlidesCompanion data) {
    return RuleSlide(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      imageRef: data.imageRef.present ? data.imageRef.value : this.imageRef,
      translationsJson: data.translationsJson.present
          ? data.translationsJson.value
          : this.translationsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuleSlide(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('imageRef: $imageRef, ')
          ..write('translationsJson: $translationsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    sortOrder,
    title,
    content,
    imageRef,
    translationsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuleSlide &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.sortOrder == this.sortOrder &&
          other.title == this.title &&
          other.content == this.content &&
          other.imageRef == this.imageRef &&
          other.translationsJson == this.translationsJson);
}

class RuleSlidesCompanion extends UpdateCompanion<RuleSlide> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<int> sortOrder;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> imageRef;
  final Value<String?> translationsJson;
  final Value<int> rowid;
  const RuleSlidesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.imageRef = const Value.absent(),
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RuleSlidesCompanion.insert({
    required String id,
    required String gameId,
    required int sortOrder,
    required String title,
    required String content,
    this.imageRef = const Value.absent(),
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       sortOrder = Value(sortOrder),
       title = Value(title),
       content = Value(content);
  static Insertable<RuleSlide> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<int>? sortOrder,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? imageRef,
    Expression<String>? translationsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (imageRef != null) 'image_ref': imageRef,
      if (translationsJson != null) 'translations_json': translationsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RuleSlidesCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<int>? sortOrder,
    Value<String>? title,
    Value<String>? content,
    Value<String?>? imageRef,
    Value<String?>? translationsJson,
    Value<int>? rowid,
  }) {
    return RuleSlidesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      sortOrder: sortOrder ?? this.sortOrder,
      title: title ?? this.title,
      content: content ?? this.content,
      imageRef: imageRef ?? this.imageRef,
      translationsJson: translationsJson ?? this.translationsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (imageRef.present) {
      map['image_ref'] = Variable<String>(imageRef.value);
    }
    if (translationsJson.present) {
      map['translations_json'] = Variable<String>(translationsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuleSlidesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('imageRef: $imageRef, ')
          ..write('translationsJson: $translationsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BadgesTable extends Badges with TableInfo<$BadgesTable, Badge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationsJsonMeta = const VerificationMeta(
    'translationsJson',
  );
  @override
  late final GeneratedColumn<String> translationsJson = GeneratedColumn<String>(
    'translations_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    name,
    description,
    icon,
    sortOrder,
    translationsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<Badge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('translations_json')) {
      context.handle(
        _translationsJsonMeta,
        translationsJson.isAcceptableOrUnknown(
          data['translations_json']!,
          _translationsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Badge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Badge(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      translationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translations_json'],
      ),
    );
  }

  @override
  $BadgesTable createAlias(String alias) {
    return $BadgesTable(attachedDatabase, alias);
  }
}

class Badge extends DataClass implements Insertable<Badge> {
  final String key;
  final String name;
  final String description;
  final String icon;
  final int sortOrder;
  final String? translationsJson;
  const Badge({
    required this.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.sortOrder,
    this.translationsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['icon'] = Variable<String>(icon);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || translationsJson != null) {
      map['translations_json'] = Variable<String>(translationsJson);
    }
    return map;
  }

  BadgesCompanion toCompanion(bool nullToAbsent) {
    return BadgesCompanion(
      key: Value(key),
      name: Value(name),
      description: Value(description),
      icon: Value(icon),
      sortOrder: Value(sortOrder),
      translationsJson: translationsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(translationsJson),
    );
  }

  factory Badge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Badge(
      key: serializer.fromJson<String>(json['key']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      translationsJson: serializer.fromJson<String?>(json['translationsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'icon': serializer.toJson<String>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'translationsJson': serializer.toJson<String?>(translationsJson),
    };
  }

  Badge copyWith({
    String? key,
    String? name,
    String? description,
    String? icon,
    int? sortOrder,
    Value<String?> translationsJson = const Value.absent(),
  }) => Badge(
    key: key ?? this.key,
    name: name ?? this.name,
    description: description ?? this.description,
    icon: icon ?? this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    translationsJson: translationsJson.present
        ? translationsJson.value
        : this.translationsJson,
  );
  Badge copyWithCompanion(BadgesCompanion data) {
    return Badge(
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      translationsJson: data.translationsJson.present
          ? data.translationsJson.value
          : this.translationsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Badge(')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('translationsJson: $translationsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key, name, description, icon, sortOrder, translationsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Badge &&
          other.key == this.key &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.translationsJson == this.translationsJson);
}

class BadgesCompanion extends UpdateCompanion<Badge> {
  final Value<String> key;
  final Value<String> name;
  final Value<String> description;
  final Value<String> icon;
  final Value<int> sortOrder;
  final Value<String?> translationsJson;
  final Value<int> rowid;
  const BadgesCompanion({
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BadgesCompanion.insert({
    required String key,
    required String name,
    required String description,
    required String icon,
    required int sortOrder,
    this.translationsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       name = Value(name),
       description = Value(description),
       icon = Value(icon),
       sortOrder = Value(sortOrder);
  static Insertable<Badge> custom({
    Expression<String>? key,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<String>? translationsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (translationsJson != null) 'translations_json': translationsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BadgesCompanion copyWith({
    Value<String>? key,
    Value<String>? name,
    Value<String>? description,
    Value<String>? icon,
    Value<int>? sortOrder,
    Value<String?>? translationsJson,
    Value<int>? rowid,
  }) {
    return BadgesCompanion(
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      translationsJson: translationsJson ?? this.translationsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (translationsJson.present) {
      map['translations_json'] = Variable<String>(translationsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesCompanion(')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('translationsJson: $translationsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentAssetsTable extends ContentAssets
    with TableInfo<$ContentAssetsTable, ContentAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _refMeta = const VerificationMeta('ref');
  @override
  late final GeneratedColumn<String> ref = GeneratedColumn<String>(
    'ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileMeta = const VerificationMeta('file');
  @override
  late final GeneratedColumn<String> file = GeneratedColumn<String>(
    'file',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<int> bytes = GeneratedColumn<int>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ref, file, hash, bytes, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentAsset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ref')) {
      context.handle(
        _refMeta,
        ref.isAcceptableOrUnknown(data['ref']!, _refMeta),
      );
    } else if (isInserting) {
      context.missing(_refMeta);
    }
    if (data.containsKey('file')) {
      context.handle(
        _fileMeta,
        file.isAcceptableOrUnknown(data['file']!, _fileMeta),
      );
    } else if (isInserting) {
      context.missing(_fileMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ref};
  @override
  ContentAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentAsset(
      ref: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref'],
      )!,
      file: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $ContentAssetsTable createAlias(String alias) {
    return $ContentAssetsTable(attachedDatabase, alias);
  }
}

class ContentAsset extends DataClass implements Insertable<ContentAsset> {
  final String ref;
  final String file;
  final String hash;
  final int bytes;
  final String type;
  const ContentAsset({
    required this.ref,
    required this.file,
    required this.hash,
    required this.bytes,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ref'] = Variable<String>(ref);
    map['file'] = Variable<String>(file);
    map['hash'] = Variable<String>(hash);
    map['bytes'] = Variable<int>(bytes);
    map['type'] = Variable<String>(type);
    return map;
  }

  ContentAssetsCompanion toCompanion(bool nullToAbsent) {
    return ContentAssetsCompanion(
      ref: Value(ref),
      file: Value(file),
      hash: Value(hash),
      bytes: Value(bytes),
      type: Value(type),
    );
  }

  factory ContentAsset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentAsset(
      ref: serializer.fromJson<String>(json['ref']),
      file: serializer.fromJson<String>(json['file']),
      hash: serializer.fromJson<String>(json['hash']),
      bytes: serializer.fromJson<int>(json['bytes']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ref': serializer.toJson<String>(ref),
      'file': serializer.toJson<String>(file),
      'hash': serializer.toJson<String>(hash),
      'bytes': serializer.toJson<int>(bytes),
      'type': serializer.toJson<String>(type),
    };
  }

  ContentAsset copyWith({
    String? ref,
    String? file,
    String? hash,
    int? bytes,
    String? type,
  }) => ContentAsset(
    ref: ref ?? this.ref,
    file: file ?? this.file,
    hash: hash ?? this.hash,
    bytes: bytes ?? this.bytes,
    type: type ?? this.type,
  );
  ContentAsset copyWithCompanion(ContentAssetsCompanion data) {
    return ContentAsset(
      ref: data.ref.present ? data.ref.value : this.ref,
      file: data.file.present ? data.file.value : this.file,
      hash: data.hash.present ? data.hash.value : this.hash,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentAsset(')
          ..write('ref: $ref, ')
          ..write('file: $file, ')
          ..write('hash: $hash, ')
          ..write('bytes: $bytes, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ref, file, hash, bytes, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentAsset &&
          other.ref == this.ref &&
          other.file == this.file &&
          other.hash == this.hash &&
          other.bytes == this.bytes &&
          other.type == this.type);
}

class ContentAssetsCompanion extends UpdateCompanion<ContentAsset> {
  final Value<String> ref;
  final Value<String> file;
  final Value<String> hash;
  final Value<int> bytes;
  final Value<String> type;
  final Value<int> rowid;
  const ContentAssetsCompanion({
    this.ref = const Value.absent(),
    this.file = const Value.absent(),
    this.hash = const Value.absent(),
    this.bytes = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentAssetsCompanion.insert({
    required String ref,
    required String file,
    required String hash,
    required int bytes,
    required String type,
    this.rowid = const Value.absent(),
  }) : ref = Value(ref),
       file = Value(file),
       hash = Value(hash),
       bytes = Value(bytes),
       type = Value(type);
  static Insertable<ContentAsset> custom({
    Expression<String>? ref,
    Expression<String>? file,
    Expression<String>? hash,
    Expression<int>? bytes,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ref != null) 'ref': ref,
      if (file != null) 'file': file,
      if (hash != null) 'hash': hash,
      if (bytes != null) 'bytes': bytes,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentAssetsCompanion copyWith({
    Value<String>? ref,
    Value<String>? file,
    Value<String>? hash,
    Value<int>? bytes,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return ContentAssetsCompanion(
      ref: ref ?? this.ref,
      file: file ?? this.file,
      hash: hash ?? this.hash,
      bytes: bytes ?? this.bytes,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ref.present) {
      map['ref'] = Variable<String>(ref.value);
    }
    if (file.present) {
      map['file'] = Variable<String>(file.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<int>(bytes.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentAssetsCompanion(')
          ..write('ref: $ref, ')
          ..write('file: $file, ')
          ..write('hash: $hash, ')
          ..write('bytes: $bytes, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentMetaTable extends ContentMeta
    with TableInfo<$ContentMetaTable, ContentMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastCheckAtMeta = const VerificationMeta(
    'lastCheckAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCheckAt = GeneratedColumn<DateTime>(
    'last_check_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, version, installedAt, lastCheckAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    if (data.containsKey('last_check_at')) {
      context.handle(
        _lastCheckAtMeta,
        lastCheckAt.isAcceptableOrUnknown(
          data['last_check_at']!,
          _lastCheckAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentMetaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
      lastCheckAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_check_at'],
      ),
    );
  }

  @override
  $ContentMetaTable createAlias(String alias) {
    return $ContentMetaTable(attachedDatabase, alias);
  }
}

class ContentMetaData extends DataClass implements Insertable<ContentMetaData> {
  final int id;
  final int version;
  final DateTime installedAt;
  final DateTime? lastCheckAt;
  const ContentMetaData({
    required this.id,
    required this.version,
    required this.installedAt,
    this.lastCheckAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version'] = Variable<int>(version);
    map['installed_at'] = Variable<DateTime>(installedAt);
    if (!nullToAbsent || lastCheckAt != null) {
      map['last_check_at'] = Variable<DateTime>(lastCheckAt);
    }
    return map;
  }

  ContentMetaCompanion toCompanion(bool nullToAbsent) {
    return ContentMetaCompanion(
      id: Value(id),
      version: Value(version),
      installedAt: Value(installedAt),
      lastCheckAt: lastCheckAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckAt),
    );
  }

  factory ContentMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentMetaData(
      id: serializer.fromJson<int>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
      lastCheckAt: serializer.fromJson<DateTime?>(json['lastCheckAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'version': serializer.toJson<int>(version),
      'installedAt': serializer.toJson<DateTime>(installedAt),
      'lastCheckAt': serializer.toJson<DateTime?>(lastCheckAt),
    };
  }

  ContentMetaData copyWith({
    int? id,
    int? version,
    DateTime? installedAt,
    Value<DateTime?> lastCheckAt = const Value.absent(),
  }) => ContentMetaData(
    id: id ?? this.id,
    version: version ?? this.version,
    installedAt: installedAt ?? this.installedAt,
    lastCheckAt: lastCheckAt.present ? lastCheckAt.value : this.lastCheckAt,
  );
  ContentMetaData copyWithCompanion(ContentMetaCompanion data) {
    return ContentMetaData(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
      lastCheckAt: data.lastCheckAt.present
          ? data.lastCheckAt.value
          : this.lastCheckAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetaData(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('installedAt: $installedAt, ')
          ..write('lastCheckAt: $lastCheckAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, version, installedAt, lastCheckAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentMetaData &&
          other.id == this.id &&
          other.version == this.version &&
          other.installedAt == this.installedAt &&
          other.lastCheckAt == this.lastCheckAt);
}

class ContentMetaCompanion extends UpdateCompanion<ContentMetaData> {
  final Value<int> id;
  final Value<int> version;
  final Value<DateTime> installedAt;
  final Value<DateTime?> lastCheckAt;
  const ContentMetaCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.lastCheckAt = const Value.absent(),
  });
  ContentMetaCompanion.insert({
    this.id = const Value.absent(),
    required int version,
    required DateTime installedAt,
    this.lastCheckAt = const Value.absent(),
  }) : version = Value(version),
       installedAt = Value(installedAt);
  static Insertable<ContentMetaData> custom({
    Expression<int>? id,
    Expression<int>? version,
    Expression<DateTime>? installedAt,
    Expression<DateTime>? lastCheckAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (installedAt != null) 'installed_at': installedAt,
      if (lastCheckAt != null) 'last_check_at': lastCheckAt,
    });
  }

  ContentMetaCompanion copyWith({
    Value<int>? id,
    Value<int>? version,
    Value<DateTime>? installedAt,
    Value<DateTime?>? lastCheckAt,
  }) {
    return ContentMetaCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      installedAt: installedAt ?? this.installedAt,
      lastCheckAt: lastCheckAt ?? this.lastCheckAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (lastCheckAt.present) {
      map['last_check_at'] = Variable<DateTime>(lastCheckAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetaCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('installedAt: $installedAt, ')
          ..write('lastCheckAt: $lastCheckAt')
          ..write(')'))
        .toString();
  }
}

class $LocalPlayersTable extends LocalPlayers
    with TableInfo<$LocalPlayersTable, LocalPlayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagScoresJsonMeta = const VerificationMeta(
    'tagScoresJson',
  );
  @override
  late final GeneratedColumn<String> tagScoresJson = GeneratedColumn<String>(
    'tag_scores_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
    'total_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _gamesPlayedMeta = const VerificationMeta(
    'gamesPlayed',
  );
  @override
  late final GeneratedColumn<int> gamesPlayed = GeneratedColumn<int>(
    'games_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _inSessionMeta = const VerificationMeta(
    'inSession',
  );
  @override
  late final GeneratedColumn<bool> inSession = GeneratedColumn<bool>(
    'in_session',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("in_session" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatar,
    tagScoresJson,
    totalScore,
    gamesPlayed,
    inSession,
    sortOrder,
    createdAt,
    remoteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_players';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPlayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarMeta);
    }
    if (data.containsKey('tag_scores_json')) {
      context.handle(
        _tagScoresJsonMeta,
        tagScoresJson.isAcceptableOrUnknown(
          data['tag_scores_json']!,
          _tagScoresJsonMeta,
        ),
      );
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('games_played')) {
      context.handle(
        _gamesPlayedMeta,
        gamesPlayed.isAcceptableOrUnknown(
          data['games_played']!,
          _gamesPlayedMeta,
        ),
      );
    }
    if (data.containsKey('in_session')) {
      context.handle(
        _inSessionMeta,
        inSession.isAcceptableOrUnknown(data['in_session']!, _inSessionMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPlayer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      )!,
      tagScoresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_scores_json'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_score'],
      )!,
      gamesPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}games_played'],
      )!,
      inSession: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}in_session'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
    );
  }

  @override
  $LocalPlayersTable createAlias(String alias) {
    return $LocalPlayersTable(attachedDatabase, alias);
  }
}

class LocalPlayer extends DataClass implements Insertable<LocalPlayer> {
  final String id;
  final String name;
  final String avatar;
  final String tagScoresJson;
  final int totalScore;
  final int gamesPlayed;
  final bool inSession;
  final int sortOrder;
  final DateTime createdAt;

  /// Renseigné au merge local → cloud (phase 4).
  final String? remoteId;
  const LocalPlayer({
    required this.id,
    required this.name,
    required this.avatar,
    required this.tagScoresJson,
    required this.totalScore,
    required this.gamesPlayed,
    required this.inSession,
    required this.sortOrder,
    required this.createdAt,
    this.remoteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['avatar'] = Variable<String>(avatar);
    map['tag_scores_json'] = Variable<String>(tagScoresJson);
    map['total_score'] = Variable<int>(totalScore);
    map['games_played'] = Variable<int>(gamesPlayed);
    map['in_session'] = Variable<bool>(inSession);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    return map;
  }

  LocalPlayersCompanion toCompanion(bool nullToAbsent) {
    return LocalPlayersCompanion(
      id: Value(id),
      name: Value(name),
      avatar: Value(avatar),
      tagScoresJson: Value(tagScoresJson),
      totalScore: Value(totalScore),
      gamesPlayed: Value(gamesPlayed),
      inSession: Value(inSession),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
    );
  }

  factory LocalPlayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPlayer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String>(json['avatar']),
      tagScoresJson: serializer.fromJson<String>(json['tagScoresJson']),
      totalScore: serializer.fromJson<int>(json['totalScore']),
      gamesPlayed: serializer.fromJson<int>(json['gamesPlayed']),
      inSession: serializer.fromJson<bool>(json['inSession']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String>(avatar),
      'tagScoresJson': serializer.toJson<String>(tagScoresJson),
      'totalScore': serializer.toJson<int>(totalScore),
      'gamesPlayed': serializer.toJson<int>(gamesPlayed),
      'inSession': serializer.toJson<bool>(inSession),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'remoteId': serializer.toJson<String?>(remoteId),
    };
  }

  LocalPlayer copyWith({
    String? id,
    String? name,
    String? avatar,
    String? tagScoresJson,
    int? totalScore,
    int? gamesPlayed,
    bool? inSession,
    int? sortOrder,
    DateTime? createdAt,
    Value<String?> remoteId = const Value.absent(),
  }) => LocalPlayer(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    tagScoresJson: tagScoresJson ?? this.tagScoresJson,
    totalScore: totalScore ?? this.totalScore,
    gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    inSession: inSession ?? this.inSession,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
  );
  LocalPlayer copyWithCompanion(LocalPlayersCompanion data) {
    return LocalPlayer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      tagScoresJson: data.tagScoresJson.present
          ? data.tagScoresJson.value
          : this.tagScoresJson,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      gamesPlayed: data.gamesPlayed.present
          ? data.gamesPlayed.value
          : this.gamesPlayed,
      inSession: data.inSession.present ? data.inSession.value : this.inSession,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlayer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('tagScoresJson: $tagScoresJson, ')
          ..write('totalScore: $totalScore, ')
          ..write('gamesPlayed: $gamesPlayed, ')
          ..write('inSession: $inSession, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    avatar,
    tagScoresJson,
    totalScore,
    gamesPlayed,
    inSession,
    sortOrder,
    createdAt,
    remoteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPlayer &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.tagScoresJson == this.tagScoresJson &&
          other.totalScore == this.totalScore &&
          other.gamesPlayed == this.gamesPlayed &&
          other.inSession == this.inSession &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.remoteId == this.remoteId);
}

class LocalPlayersCompanion extends UpdateCompanion<LocalPlayer> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> avatar;
  final Value<String> tagScoresJson;
  final Value<int> totalScore;
  final Value<int> gamesPlayed;
  final Value<bool> inSession;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<String?> remoteId;
  final Value<int> rowid;
  const LocalPlayersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.tagScoresJson = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.gamesPlayed = const Value.absent(),
    this.inSession = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPlayersCompanion.insert({
    required String id,
    required String name,
    required String avatar,
    this.tagScoresJson = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.gamesPlayed = const Value.absent(),
    this.inSession = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       avatar = Value(avatar),
       createdAt = Value(createdAt);
  static Insertable<LocalPlayer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<String>? tagScoresJson,
    Expression<int>? totalScore,
    Expression<int>? gamesPlayed,
    Expression<bool>? inSession,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<String>? remoteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (tagScoresJson != null) 'tag_scores_json': tagScoresJson,
      if (totalScore != null) 'total_score': totalScore,
      if (gamesPlayed != null) 'games_played': gamesPlayed,
      if (inSession != null) 'in_session': inSession,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (remoteId != null) 'remote_id': remoteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPlayersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? avatar,
    Value<String>? tagScoresJson,
    Value<int>? totalScore,
    Value<int>? gamesPlayed,
    Value<bool>? inSession,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<String?>? remoteId,
    Value<int>? rowid,
  }) {
    return LocalPlayersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      tagScoresJson: tagScoresJson ?? this.tagScoresJson,
      totalScore: totalScore ?? this.totalScore,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      inSession: inSession ?? this.inSession,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      remoteId: remoteId ?? this.remoteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (tagScoresJson.present) {
      map['tag_scores_json'] = Variable<String>(tagScoresJson.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (gamesPlayed.present) {
      map['games_played'] = Variable<int>(gamesPlayed.value);
    }
    if (inSession.present) {
      map['in_session'] = Variable<bool>(inSession.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlayersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('tagScoresJson: $tagScoresJson, ')
          ..write('totalScore: $totalScore, ')
          ..write('gamesPlayed: $gamesPlayed, ')
          ..write('inSession: $inSession, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('remoteId: $remoteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameSessionsTable extends GameSessions
    with TableInfo<$GameSessionsTable, GameSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardsPlayedMeta = const VerificationMeta(
    'cardsPlayed',
  );
  @override
  late final GeneratedColumn<int> cardsPlayed = GeneratedColumn<int>(
    'cards_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerCountMeta = const VerificationMeta(
    'playerCount',
  );
  @override
  late final GeneratedColumn<int> playerCount = GeneratedColumn<int>(
    'player_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    categoryId,
    locale,
    intensity,
    cardsPlayed,
    playerCount,
    startedAt,
    finishedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('cards_played')) {
      context.handle(
        _cardsPlayedMeta,
        cardsPlayed.isAcceptableOrUnknown(
          data['cards_played']!,
          _cardsPlayedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cardsPlayedMeta);
    }
    if (data.containsKey('player_count')) {
      context.handle(
        _playerCountMeta,
        playerCount.isAcceptableOrUnknown(
          data['player_count']!,
          _playerCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_playerCountMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      cardsPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cards_played'],
      )!,
      playerCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_count'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $GameSessionsTable createAlias(String alias) {
    return $GameSessionsTable(attachedDatabase, alias);
  }
}

class GameSession extends DataClass implements Insertable<GameSession> {
  /// uuid stable côté client : clé d'idempotence du merge (§05).
  final String id;
  final String gameId;
  final String categoryId;
  final String locale;
  final int intensity;
  final int cardsPlayed;
  final int playerCount;
  final DateTime startedAt;
  final DateTime finishedAt;
  final DateTime? syncedAt;
  const GameSession({
    required this.id,
    required this.gameId,
    required this.categoryId,
    required this.locale,
    required this.intensity,
    required this.cardsPlayed,
    required this.playerCount,
    required this.startedAt,
    required this.finishedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['category_id'] = Variable<String>(categoryId);
    map['locale'] = Variable<String>(locale);
    map['intensity'] = Variable<int>(intensity);
    map['cards_played'] = Variable<int>(cardsPlayed);
    map['player_count'] = Variable<int>(playerCount);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  GameSessionsCompanion toCompanion(bool nullToAbsent) {
    return GameSessionsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      categoryId: Value(categoryId),
      locale: Value(locale),
      intensity: Value(intensity),
      cardsPlayed: Value(cardsPlayed),
      playerCount: Value(playerCount),
      startedAt: Value(startedAt),
      finishedAt: Value(finishedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory GameSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameSession(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      locale: serializer.fromJson<String>(json['locale']),
      intensity: serializer.fromJson<int>(json['intensity']),
      cardsPlayed: serializer.fromJson<int>(json['cardsPlayed']),
      playerCount: serializer.fromJson<int>(json['playerCount']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'categoryId': serializer.toJson<String>(categoryId),
      'locale': serializer.toJson<String>(locale),
      'intensity': serializer.toJson<int>(intensity),
      'cardsPlayed': serializer.toJson<int>(cardsPlayed),
      'playerCount': serializer.toJson<int>(playerCount),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  GameSession copyWith({
    String? id,
    String? gameId,
    String? categoryId,
    String? locale,
    int? intensity,
    int? cardsPlayed,
    int? playerCount,
    DateTime? startedAt,
    DateTime? finishedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => GameSession(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    categoryId: categoryId ?? this.categoryId,
    locale: locale ?? this.locale,
    intensity: intensity ?? this.intensity,
    cardsPlayed: cardsPlayed ?? this.cardsPlayed,
    playerCount: playerCount ?? this.playerCount,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt ?? this.finishedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  GameSession copyWithCompanion(GameSessionsCompanion data) {
    return GameSession(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      locale: data.locale.present ? data.locale.value : this.locale,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      cardsPlayed: data.cardsPlayed.present
          ? data.cardsPlayed.value
          : this.cardsPlayed,
      playerCount: data.playerCount.present
          ? data.playerCount.value
          : this.playerCount,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameSession(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('categoryId: $categoryId, ')
          ..write('locale: $locale, ')
          ..write('intensity: $intensity, ')
          ..write('cardsPlayed: $cardsPlayed, ')
          ..write('playerCount: $playerCount, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    categoryId,
    locale,
    intensity,
    cardsPlayed,
    playerCount,
    startedAt,
    finishedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameSession &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.categoryId == this.categoryId &&
          other.locale == this.locale &&
          other.intensity == this.intensity &&
          other.cardsPlayed == this.cardsPlayed &&
          other.playerCount == this.playerCount &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.syncedAt == this.syncedAt);
}

class GameSessionsCompanion extends UpdateCompanion<GameSession> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> categoryId;
  final Value<String> locale;
  final Value<int> intensity;
  final Value<int> cardsPlayed;
  final Value<int> playerCount;
  final Value<DateTime> startedAt;
  final Value<DateTime> finishedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const GameSessionsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.locale = const Value.absent(),
    this.intensity = const Value.absent(),
    this.cardsPlayed = const Value.absent(),
    this.playerCount = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameSessionsCompanion.insert({
    required String id,
    required String gameId,
    required String categoryId,
    required String locale,
    required int intensity,
    required int cardsPlayed,
    required int playerCount,
    required DateTime startedAt,
    required DateTime finishedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       categoryId = Value(categoryId),
       locale = Value(locale),
       intensity = Value(intensity),
       cardsPlayed = Value(cardsPlayed),
       playerCount = Value(playerCount),
       startedAt = Value(startedAt),
       finishedAt = Value(finishedAt);
  static Insertable<GameSession> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? categoryId,
    Expression<String>? locale,
    Expression<int>? intensity,
    Expression<int>? cardsPlayed,
    Expression<int>? playerCount,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (categoryId != null) 'category_id': categoryId,
      if (locale != null) 'locale': locale,
      if (intensity != null) 'intensity': intensity,
      if (cardsPlayed != null) 'cards_played': cardsPlayed,
      if (playerCount != null) 'player_count': playerCount,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<String>? categoryId,
    Value<String>? locale,
    Value<int>? intensity,
    Value<int>? cardsPlayed,
    Value<int>? playerCount,
    Value<DateTime>? startedAt,
    Value<DateTime>? finishedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return GameSessionsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      categoryId: categoryId ?? this.categoryId,
      locale: locale ?? this.locale,
      intensity: intensity ?? this.intensity,
      cardsPlayed: cardsPlayed ?? this.cardsPlayed,
      playerCount: playerCount ?? this.playerCount,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (cardsPlayed.present) {
      map['cards_played'] = Variable<int>(cardsPlayed.value);
    }
    if (playerCount.present) {
      map['player_count'] = Variable<int>(playerCount.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameSessionsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('categoryId: $categoryId, ')
          ..write('locale: $locale, ')
          ..write('intensity: $intensity, ')
          ..write('cardsPlayed: $cardsPlayed, ')
          ..write('playerCount: $playerCount, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionPlayersTable extends SessionPlayers
    with TableInfo<$SessionPlayersTable, SessionPlayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionPlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES game_sessions (id)',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_players (id)',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagScoresGainedJsonMeta =
      const VerificationMeta('tagScoresGainedJson');
  @override
  late final GeneratedColumn<String> tagScoresGainedJson =
      GeneratedColumn<String>(
        'tag_scores_gained_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    playerId,
    score,
    tagScoresGainedJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_players';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionPlayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('tag_scores_gained_json')) {
      context.handle(
        _tagScoresGainedJsonMeta,
        tagScoresGainedJson.isAcceptableOrUnknown(
          data['tag_scores_gained_json']!,
          _tagScoresGainedJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tagScoresGainedJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, playerId};
  @override
  SessionPlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionPlayer(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      tagScoresGainedJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_scores_gained_json'],
      )!,
    );
  }

  @override
  $SessionPlayersTable createAlias(String alias) {
    return $SessionPlayersTable(attachedDatabase, alias);
  }
}

class SessionPlayer extends DataClass implements Insertable<SessionPlayer> {
  final String sessionId;
  final String playerId;
  final int score;
  final String tagScoresGainedJson;
  const SessionPlayer({
    required this.sessionId,
    required this.playerId,
    required this.score,
    required this.tagScoresGainedJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['player_id'] = Variable<String>(playerId);
    map['score'] = Variable<int>(score);
    map['tag_scores_gained_json'] = Variable<String>(tagScoresGainedJson);
    return map;
  }

  SessionPlayersCompanion toCompanion(bool nullToAbsent) {
    return SessionPlayersCompanion(
      sessionId: Value(sessionId),
      playerId: Value(playerId),
      score: Value(score),
      tagScoresGainedJson: Value(tagScoresGainedJson),
    );
  }

  factory SessionPlayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionPlayer(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      playerId: serializer.fromJson<String>(json['playerId']),
      score: serializer.fromJson<int>(json['score']),
      tagScoresGainedJson: serializer.fromJson<String>(
        json['tagScoresGainedJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'playerId': serializer.toJson<String>(playerId),
      'score': serializer.toJson<int>(score),
      'tagScoresGainedJson': serializer.toJson<String>(tagScoresGainedJson),
    };
  }

  SessionPlayer copyWith({
    String? sessionId,
    String? playerId,
    int? score,
    String? tagScoresGainedJson,
  }) => SessionPlayer(
    sessionId: sessionId ?? this.sessionId,
    playerId: playerId ?? this.playerId,
    score: score ?? this.score,
    tagScoresGainedJson: tagScoresGainedJson ?? this.tagScoresGainedJson,
  );
  SessionPlayer copyWithCompanion(SessionPlayersCompanion data) {
    return SessionPlayer(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      score: data.score.present ? data.score.value : this.score,
      tagScoresGainedJson: data.tagScoresGainedJson.present
          ? data.tagScoresGainedJson.value
          : this.tagScoresGainedJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionPlayer(')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('score: $score, ')
          ..write('tagScoresGainedJson: $tagScoresGainedJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, playerId, score, tagScoresGainedJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionPlayer &&
          other.sessionId == this.sessionId &&
          other.playerId == this.playerId &&
          other.score == this.score &&
          other.tagScoresGainedJson == this.tagScoresGainedJson);
}

class SessionPlayersCompanion extends UpdateCompanion<SessionPlayer> {
  final Value<String> sessionId;
  final Value<String> playerId;
  final Value<int> score;
  final Value<String> tagScoresGainedJson;
  final Value<int> rowid;
  const SessionPlayersCompanion({
    this.sessionId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.score = const Value.absent(),
    this.tagScoresGainedJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionPlayersCompanion.insert({
    required String sessionId,
    required String playerId,
    required int score,
    required String tagScoresGainedJson,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       playerId = Value(playerId),
       score = Value(score),
       tagScoresGainedJson = Value(tagScoresGainedJson);
  static Insertable<SessionPlayer> custom({
    Expression<String>? sessionId,
    Expression<String>? playerId,
    Expression<int>? score,
    Expression<String>? tagScoresGainedJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (playerId != null) 'player_id': playerId,
      if (score != null) 'score': score,
      if (tagScoresGainedJson != null)
        'tag_scores_gained_json': tagScoresGainedJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionPlayersCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? playerId,
    Value<int>? score,
    Value<String>? tagScoresGainedJson,
    Value<int>? rowid,
  }) {
    return SessionPlayersCompanion(
      sessionId: sessionId ?? this.sessionId,
      playerId: playerId ?? this.playerId,
      score: score ?? this.score,
      tagScoresGainedJson: tagScoresGainedJson ?? this.tagScoresGainedJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (tagScoresGainedJson.present) {
      map['tag_scores_gained_json'] = Variable<String>(
        tagScoresGainedJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionPlayersCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('score: $score, ')
          ..write('tagScoresGainedJson: $tagScoresGainedJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppPrefsTable extends AppPrefs with TableInfo<$AppPrefsTable, AppPref> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPrefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_prefs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPref> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppPref map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPref(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppPrefsTable createAlias(String alias) {
    return $AppPrefsTable(attachedDatabase, alias);
  }
}

class AppPref extends DataClass implements Insertable<AppPref> {
  final String key;
  final String value;
  const AppPref({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppPrefsCompanion toCompanion(bool nullToAbsent) {
    return AppPrefsCompanion(key: Value(key), value: Value(value));
  }

  factory AppPref.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPref(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppPref copyWith({String? key, String? value}) =>
      AppPref(key: key ?? this.key, value: value ?? this.value);
  AppPref copyWithCompanion(AppPrefsCompanion data) {
    return AppPref(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPref(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPref && other.key == this.key && other.value == this.value);
}

class AppPrefsCompanion extends UpdateCompanion<AppPref> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppPrefsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppPrefsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppPref> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppPrefsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppPrefsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPrefsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EarnedBadgesTable extends EarnedBadges
    with TableInfo<$EarnedBadgesTable, EarnedBadge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EarnedBadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _badgeKeyMeta = const VerificationMeta(
    'badgeKey',
  );
  @override
  late final GeneratedColumn<String> badgeKey = GeneratedColumn<String>(
    'badge_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [badgeKey, earnedAt, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'earned_badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<EarnedBadge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('badge_key')) {
      context.handle(
        _badgeKeyMeta,
        badgeKey.isAcceptableOrUnknown(data['badge_key']!, _badgeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeKeyMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {badgeKey};
  @override
  EarnedBadge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EarnedBadge(
      badgeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}badge_key'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $EarnedBadgesTable createAlias(String alias) {
    return $EarnedBadgesTable(attachedDatabase, alias);
  }
}

class EarnedBadge extends DataClass implements Insertable<EarnedBadge> {
  final String badgeKey;
  final DateTime earnedAt;

  /// Renseigné au merge local → cloud (phase 4).
  final DateTime? syncedAt;
  const EarnedBadge({
    required this.badgeKey,
    required this.earnedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['badge_key'] = Variable<String>(badgeKey);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  EarnedBadgesCompanion toCompanion(bool nullToAbsent) {
    return EarnedBadgesCompanion(
      badgeKey: Value(badgeKey),
      earnedAt: Value(earnedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory EarnedBadge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EarnedBadge(
      badgeKey: serializer.fromJson<String>(json['badgeKey']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'badgeKey': serializer.toJson<String>(badgeKey),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  EarnedBadge copyWith({
    String? badgeKey,
    DateTime? earnedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => EarnedBadge(
    badgeKey: badgeKey ?? this.badgeKey,
    earnedAt: earnedAt ?? this.earnedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  EarnedBadge copyWithCompanion(EarnedBadgesCompanion data) {
    return EarnedBadge(
      badgeKey: data.badgeKey.present ? data.badgeKey.value : this.badgeKey,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EarnedBadge(')
          ..write('badgeKey: $badgeKey, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(badgeKey, earnedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EarnedBadge &&
          other.badgeKey == this.badgeKey &&
          other.earnedAt == this.earnedAt &&
          other.syncedAt == this.syncedAt);
}

class EarnedBadgesCompanion extends UpdateCompanion<EarnedBadge> {
  final Value<String> badgeKey;
  final Value<DateTime> earnedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const EarnedBadgesCompanion({
    this.badgeKey = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EarnedBadgesCompanion.insert({
    required String badgeKey,
    required DateTime earnedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : badgeKey = Value(badgeKey),
       earnedAt = Value(earnedAt);
  static Insertable<EarnedBadge> custom({
    Expression<String>? badgeKey,
    Expression<DateTime>? earnedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (badgeKey != null) 'badge_key': badgeKey,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EarnedBadgesCompanion copyWith({
    Value<String>? badgeKey,
    Value<DateTime>? earnedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return EarnedBadgesCompanion(
      badgeKey: badgeKey ?? this.badgeKey,
      earnedAt: earnedAt ?? this.earnedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (badgeKey.present) {
      map['badge_key'] = Variable<String>(badgeKey.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EarnedBadgesCompanion(')
          ..write('badgeKey: $badgeKey, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomCardsTable extends CustomCards
    with TableInfo<$CustomCardsTable, CustomCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _text_Meta = const VerificationMeta('text_');
  @override
  late final GeneratedColumn<String> text_ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    categoryId,
    text_,
    intensity,
    active,
    createdAt,
    updatedAt,
    syncedAt,
    remoteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _text_Meta,
        text_.isAcceptableOrUnknown(data['text']!, _text_Meta),
      );
    } else if (isInserting) {
      context.missing(_text_Meta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      text_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
    );
  }

  @override
  $CustomCardsTable createAlias(String alias) {
    return $CustomCardsTable(attachedDatabase, alias);
  }
}

class CustomCard extends DataClass implements Insertable<CustomCard> {
  final String id;
  final String gameId;
  final String categoryId;
  final String text_;

  /// Pas de champ intensité au formulaire (§14, C1) — toutes les cartes
  /// perso valent l'intensité « Normal » par défaut.
  final int intensity;

  /// Active = entre dans le pool de tirage de sa catégorie (C2) ; inactive
  /// = gardée mais jamais tirée. Jamais une suppression déguisée.
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final String? remoteId;
  const CustomCard({
    required this.id,
    required this.gameId,
    required this.categoryId,
    required this.text_,
    required this.intensity,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    this.remoteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['category_id'] = Variable<String>(categoryId);
    map['text'] = Variable<String>(text_);
    map['intensity'] = Variable<int>(intensity);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    return map;
  }

  CustomCardsCompanion toCompanion(bool nullToAbsent) {
    return CustomCardsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      categoryId: Value(categoryId),
      text_: Value(text_),
      intensity: Value(intensity),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
    );
  }

  factory CustomCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomCard(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      text_: serializer.fromJson<String>(json['text_']),
      intensity: serializer.fromJson<int>(json['intensity']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'categoryId': serializer.toJson<String>(categoryId),
      'text_': serializer.toJson<String>(text_),
      'intensity': serializer.toJson<int>(intensity),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'remoteId': serializer.toJson<String?>(remoteId),
    };
  }

  CustomCard copyWith({
    String? id,
    String? gameId,
    String? categoryId,
    String? text_,
    int? intensity,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
    Value<String?> remoteId = const Value.absent(),
  }) => CustomCard(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    categoryId: categoryId ?? this.categoryId,
    text_: text_ ?? this.text_,
    intensity: intensity ?? this.intensity,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
  );
  CustomCard copyWithCompanion(CustomCardsCompanion data) {
    return CustomCard(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      text_: data.text_.present ? data.text_.value : this.text_,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomCard(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('categoryId: $categoryId, ')
          ..write('text_: $text_, ')
          ..write('intensity: $intensity, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    categoryId,
    text_,
    intensity,
    active,
    createdAt,
    updatedAt,
    syncedAt,
    remoteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomCard &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.categoryId == this.categoryId &&
          other.text_ == this.text_ &&
          other.intensity == this.intensity &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.remoteId == this.remoteId);
}

class CustomCardsCompanion extends UpdateCompanion<CustomCard> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> categoryId;
  final Value<String> text_;
  final Value<int> intensity;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<String?> remoteId;
  final Value<int> rowid;
  const CustomCardsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.text_ = const Value.absent(),
    this.intensity = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomCardsCompanion.insert({
    required String id,
    required String gameId,
    required String categoryId,
    required String text_,
    this.intensity = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       categoryId = Value(categoryId),
       text_ = Value(text_),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CustomCard> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? categoryId,
    Expression<String>? text_,
    Expression<int>? intensity,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<String>? remoteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (categoryId != null) 'category_id': categoryId,
      if (text_ != null) 'text': text_,
      if (intensity != null) 'intensity': intensity,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (remoteId != null) 'remote_id': remoteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<String>? categoryId,
    Value<String>? text_,
    Value<int>? intensity,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<String?>? remoteId,
    Value<int>? rowid,
  }) {
    return CustomCardsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      categoryId: categoryId ?? this.categoryId,
      text_: text_ ?? this.text_,
      intensity: intensity ?? this.intensity,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      remoteId: remoteId ?? this.remoteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (text_.present) {
      map['text'] = Variable<String>(text_.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomCardsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('categoryId: $categoryId, ')
          ..write('text_: $text_, ')
          ..write('intensity: $intensity, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('remoteId: $remoteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $RuleSlidesTable ruleSlides = $RuleSlidesTable(this);
  late final $BadgesTable badges = $BadgesTable(this);
  late final $ContentAssetsTable contentAssets = $ContentAssetsTable(this);
  late final $ContentMetaTable contentMeta = $ContentMetaTable(this);
  late final $LocalPlayersTable localPlayers = $LocalPlayersTable(this);
  late final $GameSessionsTable gameSessions = $GameSessionsTable(this);
  late final $SessionPlayersTable sessionPlayers = $SessionPlayersTable(this);
  late final $AppPrefsTable appPrefs = $AppPrefsTable(this);
  late final $EarnedBadgesTable earnedBadges = $EarnedBadgesTable(this);
  late final $CustomCardsTable customCards = $CustomCardsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    games,
    categories,
    cards,
    ruleSlides,
    badges,
    contentAssets,
    contentMeta,
    localPlayers,
    gameSessions,
    sessionPlayers,
    appPrefs,
    earnedBadges,
    customCards,
  ];
}

typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  required String id,
  required String slug,
  required String name,
  Value<String?> description,
  Value<String?> icon,
  required String colorMain,
  required String colorSecondary,
  required int sortOrder,
  Value<String?> translationsJson,
  Value<int> rowid,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<String> id,
  Value<String> slug,
  Value<String> name,
  Value<String?> description,
  Value<String?> icon,
  Value<String> colorMain,
  Value<String> colorSecondary,
  Value<int> sortOrder,
  Value<String?> translationsJson,
  Value<int> rowid,
});

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CategoriesTable, List<Category>>
  _categoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categories,
    aliasName: 'games__id__categories__game_id',
  );

  $$CategoriesTableProcessedTableManager get categoriesRefs {
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RuleSlidesTable, List<RuleSlide>>
  _ruleSlidesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ruleSlides,
    aliasName: 'games__id__rule_slides__game_id',
  );

  $$RuleSlidesTableProcessedTableManager get ruleSlidesRefs {
    final manager = $$RuleSlidesTableTableManager(
      $_db,
      $_db.ruleSlides,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ruleSlidesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustomCardsTable, List<CustomCard>>
  _customCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customCards,
    aliasName: 'games__id__custom_cards__game_id',
  );

  $$CustomCardsTableProcessedTableManager get customCardsRefs {
    final manager = $$CustomCardsTableTableManager(
      $_db,
      $_db.customCards,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_customCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorMain => $composableBuilder(
    column: $table.colorMain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorSecondary => $composableBuilder(
    column: $table.colorSecondary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoriesRefs(
    Expression<bool> Function($$CategoriesTableFilterComposer f) f,
  ) {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ruleSlidesRefs(
    Expression<bool> Function($$RuleSlidesTableFilterComposer f) f,
  ) {
    final $$RuleSlidesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ruleSlides,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuleSlidesTableFilterComposer(
            $db: $db,
            $table: $db.ruleSlides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> customCardsRefs(
    Expression<bool> Function($$CustomCardsTableFilterComposer f) f,
  ) {
    final $$CustomCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customCards,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomCardsTableFilterComposer(
            $db: $db,
            $table: $db.customCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorMain => $composableBuilder(
    column: $table.colorMain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorSecondary => $composableBuilder(
    column: $table.colorSecondary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get colorMain =>
      $composableBuilder(column: $table.colorMain, builder: (column) => column);

  GeneratedColumn<String> get colorSecondary => $composableBuilder(
    column: $table.colorSecondary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => column,
  );

  Expression<T> categoriesRefs<T extends Object>(
    Expression<T> Function($$CategoriesTableAnnotationComposer a) f,
  ) {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ruleSlidesRefs<T extends Object>(
    Expression<T> Function($$RuleSlidesTableAnnotationComposer a) f,
  ) {
    final $$RuleSlidesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ruleSlides,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RuleSlidesTableAnnotationComposer(
            $db: $db,
            $table: $db.ruleSlides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> customCardsRefs<T extends Object>(
    Expression<T> Function($$CustomCardsTableAnnotationComposer a) f,
  ) {
    final $$CustomCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customCards,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.customCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({
            bool categoriesRefs,
            bool ruleSlidesRefs,
            bool customCardsRefs,
          })
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String> colorMain = const Value.absent(),
                Value<String> colorSecondary = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                slug: slug,
                name: name,
                description: description,
                icon: icon,
                colorMain: colorMain,
                colorSecondary: colorSecondary,
                sortOrder: sortOrder,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String slug,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                required String colorMain,
                required String colorSecondary,
                required int sortOrder,
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                slug: slug,
                name: name,
                description: description,
                icon: icon,
                colorMain: colorMain,
                colorSecondary: colorSecondary,
                sortOrder: sortOrder,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GamesTable, Game>(table),
                  $$GamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoriesRefs = false,
                ruleSlidesRefs = false,
                customCardsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoriesRefs) db.categories,
                    if (ruleSlidesRefs) db.ruleSlides,
                    if (customCardsRefs) db.customCards,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoriesRefs)
                        await $_getPrefetchedData<Game, $GamesTable, Category>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._categoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ruleSlidesRefs)
                        await $_getPrefetchedData<Game, $GamesTable, RuleSlide>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._ruleSlidesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).ruleSlidesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (customCardsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          CustomCard
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._customCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).customCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({
        bool categoriesRefs,
        bool ruleSlidesRefs,
        bool customCardsRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String gameId,
  required String slug,
  required String name,
  Value<String?> description,
  Value<String?> icon,
  required int sortOrder,
  Value<String> tier,
  Value<String?> translationsJson,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> gameId,
  Value<String> slug,
  Value<String> name,
  Value<String?> description,
  Value<String?> icon,
  Value<int> sortOrder,
  Value<String> tier,
  Value<String?> translationsJson,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('categories__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CardsTable, List<Card>> _cardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cards,
    aliasName: 'categories__id__cards__category_id',
  );

  $$CardsTableProcessedTableManager get cardsRefs {
    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustomCardsTable, List<CustomCard>>
  _customCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customCards,
    aliasName: 'categories__id__custom_cards__category_id',
  );

  $$CustomCardsTableProcessedTableManager get customCardsRefs {
    final manager = $$CustomCardsTableTableManager(
      $_db,
      $_db.customCards,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_customCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cardsRefs(
    Expression<bool> Function($$CardsTableFilterComposer f) f,
  ) {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> customCardsRefs(
    Expression<bool> Function($$CustomCardsTableFilterComposer f) f,
  ) {
    final $$CustomCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customCards,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomCardsTableFilterComposer(
            $db: $db,
            $table: $db.customCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cardsRefs<T extends Object>(
    Expression<T> Function($$CardsTableAnnotationComposer a) f,
  ) {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> customCardsRefs<T extends Object>(
    Expression<T> Function($$CustomCardsTableAnnotationComposer a) f,
  ) {
    final $$CustomCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customCards,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.customCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool gameId,
            bool cardsRefs,
            bool customCardsRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                gameId: gameId,
                slug: slug,
                name: name,
                description: description,
                icon: icon,
                sortOrder: sortOrder,
                tier: tier,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required String slug,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                required int sortOrder,
                Value<String> tier = const Value.absent(),
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                gameId: gameId,
                slug: slug,
                name: name,
                description: description,
                icon: icon,
                sortOrder: sortOrder,
                tier: tier,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gameId = false, cardsRefs = false, customCardsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cardsRefs) db.cards,
                    if (customCardsRefs) db.customCards,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gameId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gameId,
                            referencedTable: $$CategoriesTableReferences
                                ._gameIdTable(db),
                            referencedColumn: $$CategoriesTableReferences
                                ._gameIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cardsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Card
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._cardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).cardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (customCardsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          CustomCard
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._customCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).customCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({
        bool gameId,
        bool cardsRefs,
        bool customCardsRefs,
      })
    >;
typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  required String id,
  required String categoryId,
  required String text_,
  required int intensity,
  required String tagsJson,
  required String canonicalTagsJson,
  required int sortOrder,
  Value<String> tier,
  Value<String?> translationsJson,
  Value<int> rowid,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<String> id,
  Value<String> categoryId,
  Value<String> text_,
  Value<int> intensity,
  Value<String> tagsJson,
  Value<String> canonicalTagsJson,
  Value<int> sortOrder,
  Value<String> tier,
  Value<String?> translationsJson,
  Value<int> rowid,
});

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, Card> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('cards__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalTagsJson => $composableBuilder(
    column: $table.canonicalTagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalTagsJson => $composableBuilder(
    column: $table.canonicalTagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get text_ =>
      $composableBuilder(column: $table.text_, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get canonicalTagsJson => $composableBuilder(
    column: $table.canonicalTagsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          Card,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (Card, $$CardsTableReferences),
          Card,
          PrefetchHooks Function({bool categoryId})
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> text_ = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String> canonicalTagsJson = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                categoryId: categoryId,
                text_: text_,
                intensity: intensity,
                tagsJson: tagsJson,
                canonicalTagsJson: canonicalTagsJson,
                sortOrder: sortOrder,
                tier: tier,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryId,
                required String text_,
                required int intensity,
                required String tagsJson,
                required String canonicalTagsJson,
                required int sortOrder,
                Value<String> tier = const Value.absent(),
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                categoryId: categoryId,
                text_: text_,
                intensity: intensity,
                tagsJson: tagsJson,
                canonicalTagsJson: canonicalTagsJson,
                sortOrder: sortOrder,
                tier: tier,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardsTable, Card>(table),
                  $$CardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$CardsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$CardsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      Card,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (Card, $$CardsTableReferences),
      Card,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$RuleSlidesTableCreateCompanionBuilder = RuleSlidesCompanion Function({
  required String id,
  required String gameId,
  required int sortOrder,
  required String title,
  required String content,
  Value<String?> imageRef,
  Value<String?> translationsJson,
  Value<int> rowid,
});
typedef $$RuleSlidesTableUpdateCompanionBuilder = RuleSlidesCompanion Function({
  Value<String> id,
  Value<String> gameId,
  Value<int> sortOrder,
  Value<String> title,
  Value<String> content,
  Value<String?> imageRef,
  Value<String?> translationsJson,
  Value<int> rowid,
});

final class $$RuleSlidesTableReferences
    extends BaseReferences<_$AppDatabase, $RuleSlidesTable, RuleSlide> {
  $$RuleSlidesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('rule_slides__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RuleSlidesTableFilterComposer
    extends Composer<_$AppDatabase, $RuleSlidesTable> {
  $$RuleSlidesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageRef => $composableBuilder(
    column: $table.imageRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuleSlidesTableOrderingComposer
    extends Composer<_$AppDatabase, $RuleSlidesTable> {
  $$RuleSlidesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageRef => $composableBuilder(
    column: $table.imageRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuleSlidesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RuleSlidesTable> {
  $$RuleSlidesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get imageRef =>
      $composableBuilder(column: $table.imageRef, builder: (column) => column);

  GeneratedColumn<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuleSlidesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RuleSlidesTable,
          RuleSlide,
          $$RuleSlidesTableFilterComposer,
          $$RuleSlidesTableOrderingComposer,
          $$RuleSlidesTableAnnotationComposer,
          $$RuleSlidesTableCreateCompanionBuilder,
          $$RuleSlidesTableUpdateCompanionBuilder,
          (RuleSlide, $$RuleSlidesTableReferences),
          RuleSlide,
          PrefetchHooks Function({bool gameId})
        > {
  $$RuleSlidesTableTableManager(_$AppDatabase db, $RuleSlidesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuleSlidesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RuleSlidesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RuleSlidesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> imageRef = const Value.absent(),
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RuleSlidesCompanion(
                id: id,
                gameId: gameId,
                sortOrder: sortOrder,
                title: title,
                content: content,
                imageRef: imageRef,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required int sortOrder,
                required String title,
                required String content,
                Value<String?> imageRef = const Value.absent(),
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RuleSlidesCompanion.insert(
                id: id,
                gameId: gameId,
                sortOrder: sortOrder,
                title: title,
                content: content,
                imageRef: imageRef,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RuleSlidesTable, RuleSlide>(table),
                  $$RuleSlidesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.gameId,
                        referencedTable: $$RuleSlidesTableReferences
                            ._gameIdTable(db),
                        referencedColumn: $$RuleSlidesTableReferences
                            ._gameIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RuleSlidesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RuleSlidesTable,
      RuleSlide,
      $$RuleSlidesTableFilterComposer,
      $$RuleSlidesTableOrderingComposer,
      $$RuleSlidesTableAnnotationComposer,
      $$RuleSlidesTableCreateCompanionBuilder,
      $$RuleSlidesTableUpdateCompanionBuilder,
      (RuleSlide, $$RuleSlidesTableReferences),
      RuleSlide,
      PrefetchHooks Function({bool gameId})
    >;
typedef $$BadgesTableCreateCompanionBuilder = BadgesCompanion Function({
  required String key,
  required String name,
  required String description,
  required String icon,
  required int sortOrder,
  Value<String?> translationsJson,
  Value<int> rowid,
});
typedef $$BadgesTableUpdateCompanionBuilder = BadgesCompanion Function({
  Value<String> key,
  Value<String> name,
  Value<String> description,
  Value<String> icon,
  Value<int> sortOrder,
  Value<String?> translationsJson,
  Value<int> rowid,
});

class $$BadgesTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get translationsJson => $composableBuilder(
    column: $table.translationsJson,
    builder: (column) => column,
  );
}

class $$BadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTable,
          Badge,
          $$BadgesTableFilterComposer,
          $$BadgesTableOrderingComposer,
          $$BadgesTableAnnotationComposer,
          $$BadgesTableCreateCompanionBuilder,
          $$BadgesTableUpdateCompanionBuilder,
          (Badge, BaseReferences<_$AppDatabase, $BadgesTable, Badge>),
          Badge,
          PrefetchHooks Function()
        > {
  $$BadgesTableTableManager(_$AppDatabase db, $BadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BadgesCompanion(
                key: key,
                name: name,
                description: description,
                icon: icon,
                sortOrder: sortOrder,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String name,
                required String description,
                required String icon,
                required int sortOrder,
                Value<String?> translationsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BadgesCompanion.insert(
                key: key,
                name: name,
                description: description,
                icon: icon,
                sortOrder: sortOrder,
                translationsJson: translationsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BadgesTable, Badge>(table),
                  BaseReferences<_$AppDatabase, $BadgesTable, Badge>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTable,
      Badge,
      $$BadgesTableFilterComposer,
      $$BadgesTableOrderingComposer,
      $$BadgesTableAnnotationComposer,
      $$BadgesTableCreateCompanionBuilder,
      $$BadgesTableUpdateCompanionBuilder,
      (Badge, BaseReferences<_$AppDatabase, $BadgesTable, Badge>),
      Badge,
      PrefetchHooks Function()
    >;
typedef $$ContentAssetsTableCreateCompanionBuilder =
    ContentAssetsCompanion Function({
      required String ref,
      required String file,
      required String hash,
      required int bytes,
      required String type,
      Value<int> rowid,
    });
typedef $$ContentAssetsTableUpdateCompanionBuilder =
    ContentAssetsCompanion Function({
      Value<String> ref,
      Value<String> file,
      Value<String> hash,
      Value<int> bytes,
      Value<String> type,
      Value<int> rowid,
    });

class $$ContentAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentAssetsTable> {
  $$ContentAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ref => $composableBuilder(
    column: $table.ref,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get file => $composableBuilder(
    column: $table.file,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentAssetsTable> {
  $$ContentAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ref => $composableBuilder(
    column: $table.ref,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get file => $composableBuilder(
    column: $table.file,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentAssetsTable> {
  $$ContentAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ref =>
      $composableBuilder(column: $table.ref, builder: (column) => column);

  GeneratedColumn<String> get file =>
      $composableBuilder(column: $table.file, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<int> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$ContentAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentAssetsTable,
          ContentAsset,
          $$ContentAssetsTableFilterComposer,
          $$ContentAssetsTableOrderingComposer,
          $$ContentAssetsTableAnnotationComposer,
          $$ContentAssetsTableCreateCompanionBuilder,
          $$ContentAssetsTableUpdateCompanionBuilder,
          (
            ContentAsset,
            BaseReferences<_$AppDatabase, $ContentAssetsTable, ContentAsset>,
          ),
          ContentAsset,
          PrefetchHooks Function()
        > {
  $$ContentAssetsTableTableManager(_$AppDatabase db, $ContentAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> ref = const Value.absent(),
                Value<String> file = const Value.absent(),
                Value<String> hash = const Value.absent(),
                Value<int> bytes = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentAssetsCompanion(
                ref: ref,
                file: file,
                hash: hash,
                bytes: bytes,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ref,
                required String file,
                required String hash,
                required int bytes,
                required String type,
                Value<int> rowid = const Value.absent(),
              }) => ContentAssetsCompanion.insert(
                ref: ref,
                file: file,
                hash: hash,
                bytes: bytes,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentAssetsTable, ContentAsset>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ContentAssetsTable,
                    ContentAsset
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentAssetsTable,
      ContentAsset,
      $$ContentAssetsTableFilterComposer,
      $$ContentAssetsTableOrderingComposer,
      $$ContentAssetsTableAnnotationComposer,
      $$ContentAssetsTableCreateCompanionBuilder,
      $$ContentAssetsTableUpdateCompanionBuilder,
      (
        ContentAsset,
        BaseReferences<_$AppDatabase, $ContentAssetsTable, ContentAsset>,
      ),
      ContentAsset,
      PrefetchHooks Function()
    >;
typedef $$ContentMetaTableCreateCompanionBuilder =
    ContentMetaCompanion Function({
      Value<int> id,
      required int version,
      required DateTime installedAt,
      Value<DateTime?> lastCheckAt,
    });
typedef $$ContentMetaTableUpdateCompanionBuilder =
    ContentMetaCompanion Function({
      Value<int> id,
      Value<int> version,
      Value<DateTime> installedAt,
      Value<DateTime?> lastCheckAt,
    });

class $$ContentMetaTableFilterComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCheckAt => $composableBuilder(
    column: $table.lastCheckAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCheckAt => $composableBuilder(
    column: $table.lastCheckAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCheckAt => $composableBuilder(
    column: $table.lastCheckAt,
    builder: (column) => column,
  );
}

class $$ContentMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentMetaTable,
          ContentMetaData,
          $$ContentMetaTableFilterComposer,
          $$ContentMetaTableOrderingComposer,
          $$ContentMetaTableAnnotationComposer,
          $$ContentMetaTableCreateCompanionBuilder,
          $$ContentMetaTableUpdateCompanionBuilder,
          (
            ContentMetaData,
            BaseReferences<_$AppDatabase, $ContentMetaTable, ContentMetaData>,
          ),
          ContentMetaData,
          PrefetchHooks Function()
        > {
  $$ContentMetaTableTableManager(_$AppDatabase db, $ContentMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<DateTime?> lastCheckAt = const Value.absent(),
              }) => ContentMetaCompanion(
                id: id,
                version: version,
                installedAt: installedAt,
                lastCheckAt: lastCheckAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int version,
                required DateTime installedAt,
                Value<DateTime?> lastCheckAt = const Value.absent(),
              }) => ContentMetaCompanion.insert(
                id: id,
                version: version,
                installedAt: installedAt,
                lastCheckAt: lastCheckAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentMetaTable, ContentMetaData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ContentMetaTable,
                    ContentMetaData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentMetaTable,
      ContentMetaData,
      $$ContentMetaTableFilterComposer,
      $$ContentMetaTableOrderingComposer,
      $$ContentMetaTableAnnotationComposer,
      $$ContentMetaTableCreateCompanionBuilder,
      $$ContentMetaTableUpdateCompanionBuilder,
      (
        ContentMetaData,
        BaseReferences<_$AppDatabase, $ContentMetaTable, ContentMetaData>,
      ),
      ContentMetaData,
      PrefetchHooks Function()
    >;
typedef $$LocalPlayersTableCreateCompanionBuilder =
    LocalPlayersCompanion Function({
      required String id,
      required String name,
      required String avatar,
      Value<String> tagScoresJson,
      Value<int> totalScore,
      Value<int> gamesPlayed,
      Value<bool> inSession,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<String?> remoteId,
      Value<int> rowid,
    });
typedef $$LocalPlayersTableUpdateCompanionBuilder =
    LocalPlayersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> avatar,
      Value<String> tagScoresJson,
      Value<int> totalScore,
      Value<int> gamesPlayed,
      Value<bool> inSession,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<String?> remoteId,
      Value<int> rowid,
    });

final class $$LocalPlayersTableReferences
    extends BaseReferences<_$AppDatabase, $LocalPlayersTable, LocalPlayer> {
  $$LocalPlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionPlayersTable, List<SessionPlayer>>
  _sessionPlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionPlayers,
    aliasName: 'local_players__id__session_players__player_id',
  );

  $$SessionPlayersTableProcessedTableManager get sessionPlayersRefs {
    final manager = $$SessionPlayersTableTableManager(
      $_db,
      $_db.sessionPlayers,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionPlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalPlayersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPlayersTable> {
  $$LocalPlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagScoresJson => $composableBuilder(
    column: $table.tagScoresJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inSession => $composableBuilder(
    column: $table.inSession,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionPlayersRefs(
    Expression<bool> Function($$SessionPlayersTableFilterComposer f) f,
  ) {
    final $$SessionPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionPlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionPlayersTableFilterComposer(
            $db: $db,
            $table: $db.sessionPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalPlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPlayersTable> {
  $$LocalPlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagScoresJson => $composableBuilder(
    column: $table.tagScoresJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inSession => $composableBuilder(
    column: $table.inSession,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPlayersTable> {
  $$LocalPlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get tagScoresJson => $composableBuilder(
    column: $table.tagScoresJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gamesPlayed => $composableBuilder(
    column: $table.gamesPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get inSession =>
      $composableBuilder(column: $table.inSession, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  Expression<T> sessionPlayersRefs<T extends Object>(
    Expression<T> Function($$SessionPlayersTableAnnotationComposer a) f,
  ) {
    final $$SessionPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionPlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocalPlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPlayersTable,
          LocalPlayer,
          $$LocalPlayersTableFilterComposer,
          $$LocalPlayersTableOrderingComposer,
          $$LocalPlayersTableAnnotationComposer,
          $$LocalPlayersTableCreateCompanionBuilder,
          $$LocalPlayersTableUpdateCompanionBuilder,
          (LocalPlayer, $$LocalPlayersTableReferences),
          LocalPlayer,
          PrefetchHooks Function({bool sessionPlayersRefs})
        > {
  $$LocalPlayersTableTableManager(_$AppDatabase db, $LocalPlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> avatar = const Value.absent(),
                Value<String> tagScoresJson = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<int> gamesPlayed = const Value.absent(),
                Value<bool> inSession = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPlayersCompanion(
                id: id,
                name: name,
                avatar: avatar,
                tagScoresJson: tagScoresJson,
                totalScore: totalScore,
                gamesPlayed: gamesPlayed,
                inSession: inSession,
                sortOrder: sortOrder,
                createdAt: createdAt,
                remoteId: remoteId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String avatar,
                Value<String> tagScoresJson = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<int> gamesPlayed = const Value.absent(),
                Value<bool> inSession = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<String?> remoteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPlayersCompanion.insert(
                id: id,
                name: name,
                avatar: avatar,
                tagScoresJson: tagScoresJson,
                totalScore: totalScore,
                gamesPlayed: gamesPlayed,
                inSession: inSession,
                sortOrder: sortOrder,
                createdAt: createdAt,
                remoteId: remoteId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalPlayersTable, LocalPlayer>(table),
                  $$LocalPlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionPlayersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionPlayersRefs) db.sessionPlayers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionPlayersRefs)
                    await $_getPrefetchedData<
                      LocalPlayer,
                      $LocalPlayersTable,
                      SessionPlayer
                    >(
                      currentTable: table,
                      referencedTable: $$LocalPlayersTableReferences
                          ._sessionPlayersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocalPlayersTableReferences(
                            db,
                            table,
                            p0,
                          ).sessionPlayersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocalPlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPlayersTable,
      LocalPlayer,
      $$LocalPlayersTableFilterComposer,
      $$LocalPlayersTableOrderingComposer,
      $$LocalPlayersTableAnnotationComposer,
      $$LocalPlayersTableCreateCompanionBuilder,
      $$LocalPlayersTableUpdateCompanionBuilder,
      (LocalPlayer, $$LocalPlayersTableReferences),
      LocalPlayer,
      PrefetchHooks Function({bool sessionPlayersRefs})
    >;
typedef $$GameSessionsTableCreateCompanionBuilder =
    GameSessionsCompanion Function({
      required String id,
      required String gameId,
      required String categoryId,
      required String locale,
      required int intensity,
      required int cardsPlayed,
      required int playerCount,
      required DateTime startedAt,
      required DateTime finishedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$GameSessionsTableUpdateCompanionBuilder =
    GameSessionsCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<String> categoryId,
      Value<String> locale,
      Value<int> intensity,
      Value<int> cardsPlayed,
      Value<int> playerCount,
      Value<DateTime> startedAt,
      Value<DateTime> finishedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

final class $$GameSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $GameSessionsTable, GameSession> {
  $$GameSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionPlayersTable, List<SessionPlayer>>
  _sessionPlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionPlayers,
    aliasName: 'game_sessions__id__session_players__session_id',
  );

  $$SessionPlayersTableProcessedTableManager get sessionPlayersRefs {
    final manager = $$SessionPlayersTableTableManager(
      $_db,
      $_db.sessionPlayers,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionPlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GameSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardsPlayed => $composableBuilder(
    column: $table.cardsPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playerCount => $composableBuilder(
    column: $table.playerCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionPlayersRefs(
    Expression<bool> Function($$SessionPlayersTableFilterComposer f) f,
  ) {
    final $$SessionPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionPlayers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionPlayersTableFilterComposer(
            $db: $db,
            $table: $db.sessionPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GameSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardsPlayed => $composableBuilder(
    column: $table.cardsPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playerCount => $composableBuilder(
    column: $table.playerCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<int> get cardsPlayed => $composableBuilder(
    column: $table.cardsPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playerCount => $composableBuilder(
    column: $table.playerCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> sessionPlayersRefs<T extends Object>(
    Expression<T> Function($$SessionPlayersTableAnnotationComposer a) f,
  ) {
    final $$SessionPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionPlayers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GameSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameSessionsTable,
          GameSession,
          $$GameSessionsTableFilterComposer,
          $$GameSessionsTableOrderingComposer,
          $$GameSessionsTableAnnotationComposer,
          $$GameSessionsTableCreateCompanionBuilder,
          $$GameSessionsTableUpdateCompanionBuilder,
          (GameSession, $$GameSessionsTableReferences),
          GameSession,
          PrefetchHooks Function({bool sessionPlayersRefs})
        > {
  $$GameSessionsTableTableManager(_$AppDatabase db, $GameSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<int> cardsPlayed = const Value.absent(),
                Value<int> playerCount = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> finishedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameSessionsCompanion(
                id: id,
                gameId: gameId,
                categoryId: categoryId,
                locale: locale,
                intensity: intensity,
                cardsPlayed: cardsPlayed,
                playerCount: playerCount,
                startedAt: startedAt,
                finishedAt: finishedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required String categoryId,
                required String locale,
                required int intensity,
                required int cardsPlayed,
                required int playerCount,
                required DateTime startedAt,
                required DateTime finishedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameSessionsCompanion.insert(
                id: id,
                gameId: gameId,
                categoryId: categoryId,
                locale: locale,
                intensity: intensity,
                cardsPlayed: cardsPlayed,
                playerCount: playerCount,
                startedAt: startedAt,
                finishedAt: finishedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GameSessionsTable, GameSession>(table),
                  $$GameSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionPlayersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sessionPlayersRefs) db.sessionPlayers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionPlayersRefs)
                    await $_getPrefetchedData<
                      GameSession,
                      $GameSessionsTable,
                      SessionPlayer
                    >(
                      currentTable: table,
                      referencedTable: $$GameSessionsTableReferences
                          ._sessionPlayersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GameSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).sessionPlayersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GameSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameSessionsTable,
      GameSession,
      $$GameSessionsTableFilterComposer,
      $$GameSessionsTableOrderingComposer,
      $$GameSessionsTableAnnotationComposer,
      $$GameSessionsTableCreateCompanionBuilder,
      $$GameSessionsTableUpdateCompanionBuilder,
      (GameSession, $$GameSessionsTableReferences),
      GameSession,
      PrefetchHooks Function({bool sessionPlayersRefs})
    >;
typedef $$SessionPlayersTableCreateCompanionBuilder =
    SessionPlayersCompanion Function({
      required String sessionId,
      required String playerId,
      required int score,
      required String tagScoresGainedJson,
      Value<int> rowid,
    });
typedef $$SessionPlayersTableUpdateCompanionBuilder =
    SessionPlayersCompanion Function({
      Value<String> sessionId,
      Value<String> playerId,
      Value<int> score,
      Value<String> tagScoresGainedJson,
      Value<int> rowid,
    });

final class $$SessionPlayersTableReferences
    extends BaseReferences<_$AppDatabase, $SessionPlayersTable, SessionPlayer> {
  $$SessionPlayersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GameSessionsTable _sessionIdTable(_$AppDatabase db) => db.gameSessions
      .createAlias('session_players__session_id__game_sessions__id');

  $$GameSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$GameSessionsTableTableManager(
      $_db,
      $_db.gameSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocalPlayersTable _playerIdTable(_$AppDatabase db) => db.localPlayers
      .createAlias('session_players__player_id__local_players__id');

  $$LocalPlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<String>('player_id')!;

    final manager = $$LocalPlayersTableTableManager(
      $_db,
      $_db.localPlayers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionPlayersTableFilterComposer
    extends Composer<_$AppDatabase, $SessionPlayersTable> {
  $$SessionPlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagScoresGainedJson => $composableBuilder(
    column: $table.tagScoresGainedJson,
    builder: (column) => ColumnFilters(column),
  );

  $$GameSessionsTableFilterComposer get sessionId {
    final $$GameSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableFilterComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalPlayersTableFilterComposer get playerId {
    final $$LocalPlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.localPlayers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalPlayersTableFilterComposer(
            $db: $db,
            $table: $db.localPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionPlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionPlayersTable> {
  $$SessionPlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagScoresGainedJson => $composableBuilder(
    column: $table.tagScoresGainedJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$GameSessionsTableOrderingComposer get sessionId {
    final $$GameSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalPlayersTableOrderingComposer get playerId {
    final $$LocalPlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.localPlayers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalPlayersTableOrderingComposer(
            $db: $db,
            $table: $db.localPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionPlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionPlayersTable> {
  $$SessionPlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get tagScoresGainedJson => $composableBuilder(
    column: $table.tagScoresGainedJson,
    builder: (column) => column,
  );

  $$GameSessionsTableAnnotationComposer get sessionId {
    final $$GameSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocalPlayersTableAnnotationComposer get playerId {
    final $$LocalPlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.localPlayers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalPlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.localPlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionPlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionPlayersTable,
          SessionPlayer,
          $$SessionPlayersTableFilterComposer,
          $$SessionPlayersTableOrderingComposer,
          $$SessionPlayersTableAnnotationComposer,
          $$SessionPlayersTableCreateCompanionBuilder,
          $$SessionPlayersTableUpdateCompanionBuilder,
          (SessionPlayer, $$SessionPlayersTableReferences),
          SessionPlayer,
          PrefetchHooks Function({bool sessionId, bool playerId})
        > {
  $$SessionPlayersTableTableManager(
    _$AppDatabase db,
    $SessionPlayersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionPlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionPlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionPlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<String> tagScoresGainedJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionPlayersCompanion(
                sessionId: sessionId,
                playerId: playerId,
                score: score,
                tagScoresGainedJson: tagScoresGainedJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String playerId,
                required int score,
                required String tagScoresGainedJson,
                Value<int> rowid = const Value.absent(),
              }) => SessionPlayersCompanion.insert(
                sessionId: sessionId,
                playerId: playerId,
                score: score,
                tagScoresGainedJson: tagScoresGainedJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionPlayersTable, SessionPlayer>(table),
                  $$SessionPlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, playerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SessionPlayersTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SessionPlayersTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (playerId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.playerId,
                        referencedTable: $$SessionPlayersTableReferences
                            ._playerIdTable(db),
                        referencedColumn: $$SessionPlayersTableReferences
                            ._playerIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionPlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionPlayersTable,
      SessionPlayer,
      $$SessionPlayersTableFilterComposer,
      $$SessionPlayersTableOrderingComposer,
      $$SessionPlayersTableAnnotationComposer,
      $$SessionPlayersTableCreateCompanionBuilder,
      $$SessionPlayersTableUpdateCompanionBuilder,
      (SessionPlayer, $$SessionPlayersTableReferences),
      SessionPlayer,
      PrefetchHooks Function({bool sessionId, bool playerId})
    >;
typedef $$AppPrefsTableCreateCompanionBuilder = AppPrefsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppPrefsTableUpdateCompanionBuilder = AppPrefsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppPrefsTableFilterComposer
    extends Composer<_$AppDatabase, $AppPrefsTable> {
  $$AppPrefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppPrefsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPrefsTable> {
  $$AppPrefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppPrefsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPrefsTable> {
  $$AppPrefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppPrefsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppPrefsTable,
          AppPref,
          $$AppPrefsTableFilterComposer,
          $$AppPrefsTableOrderingComposer,
          $$AppPrefsTableAnnotationComposer,
          $$AppPrefsTableCreateCompanionBuilder,
          $$AppPrefsTableUpdateCompanionBuilder,
          (AppPref, BaseReferences<_$AppDatabase, $AppPrefsTable, AppPref>),
          AppPref,
          PrefetchHooks Function()
        > {
  $$AppPrefsTableTableManager(_$AppDatabase db, $AppPrefsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPrefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPrefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPrefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppPrefsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => AppPrefsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppPrefsTable, AppPref>(table),
                  BaseReferences<_$AppDatabase, $AppPrefsTable, AppPref>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppPrefsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppPrefsTable,
      AppPref,
      $$AppPrefsTableFilterComposer,
      $$AppPrefsTableOrderingComposer,
      $$AppPrefsTableAnnotationComposer,
      $$AppPrefsTableCreateCompanionBuilder,
      $$AppPrefsTableUpdateCompanionBuilder,
      (AppPref, BaseReferences<_$AppDatabase, $AppPrefsTable, AppPref>),
      AppPref,
      PrefetchHooks Function()
    >;
typedef $$EarnedBadgesTableCreateCompanionBuilder =
    EarnedBadgesCompanion Function({
      required String badgeKey,
      required DateTime earnedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$EarnedBadgesTableUpdateCompanionBuilder =
    EarnedBadgesCompanion Function({
      Value<String> badgeKey,
      Value<DateTime> earnedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$EarnedBadgesTableFilterComposer
    extends Composer<_$AppDatabase, $EarnedBadgesTable> {
  $$EarnedBadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get badgeKey => $composableBuilder(
    column: $table.badgeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EarnedBadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $EarnedBadgesTable> {
  $$EarnedBadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get badgeKey => $composableBuilder(
    column: $table.badgeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EarnedBadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EarnedBadgesTable> {
  $$EarnedBadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get badgeKey =>
      $composableBuilder(column: $table.badgeKey, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$EarnedBadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EarnedBadgesTable,
          EarnedBadge,
          $$EarnedBadgesTableFilterComposer,
          $$EarnedBadgesTableOrderingComposer,
          $$EarnedBadgesTableAnnotationComposer,
          $$EarnedBadgesTableCreateCompanionBuilder,
          $$EarnedBadgesTableUpdateCompanionBuilder,
          (
            EarnedBadge,
            BaseReferences<_$AppDatabase, $EarnedBadgesTable, EarnedBadge>,
          ),
          EarnedBadge,
          PrefetchHooks Function()
        > {
  $$EarnedBadgesTableTableManager(_$AppDatabase db, $EarnedBadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EarnedBadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EarnedBadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EarnedBadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> badgeKey = const Value.absent(),
                Value<DateTime> earnedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EarnedBadgesCompanion(
                badgeKey: badgeKey,
                earnedAt: earnedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String badgeKey,
                required DateTime earnedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EarnedBadgesCompanion.insert(
                badgeKey: badgeKey,
                earnedAt: earnedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EarnedBadgesTable, EarnedBadge>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EarnedBadgesTable,
                    EarnedBadge
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EarnedBadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EarnedBadgesTable,
      EarnedBadge,
      $$EarnedBadgesTableFilterComposer,
      $$EarnedBadgesTableOrderingComposer,
      $$EarnedBadgesTableAnnotationComposer,
      $$EarnedBadgesTableCreateCompanionBuilder,
      $$EarnedBadgesTableUpdateCompanionBuilder,
      (
        EarnedBadge,
        BaseReferences<_$AppDatabase, $EarnedBadgesTable, EarnedBadge>,
      ),
      EarnedBadge,
      PrefetchHooks Function()
    >;
typedef $$CustomCardsTableCreateCompanionBuilder =
    CustomCardsCompanion Function({
      required String id,
      required String gameId,
      required String categoryId,
      required String text_,
      Value<int> intensity,
      Value<bool> active,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<String?> remoteId,
      Value<int> rowid,
    });
typedef $$CustomCardsTableUpdateCompanionBuilder =
    CustomCardsCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<String> categoryId,
      Value<String> text_,
      Value<int> intensity,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<String?> remoteId,
      Value<int> rowid,
    });

final class $$CustomCardsTableReferences
    extends BaseReferences<_$AppDatabase, $CustomCardsTable, CustomCard> {
  $$CustomCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('custom_cards__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('custom_cards__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CustomCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomCardsTable> {
  $$CustomCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get text_ =>
      $composableBuilder(column: $table.text_, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomCardsTable,
          CustomCard,
          $$CustomCardsTableFilterComposer,
          $$CustomCardsTableOrderingComposer,
          $$CustomCardsTableAnnotationComposer,
          $$CustomCardsTableCreateCompanionBuilder,
          $$CustomCardsTableUpdateCompanionBuilder,
          (CustomCard, $$CustomCardsTableReferences),
          CustomCard,
          PrefetchHooks Function({bool gameId, bool categoryId})
        > {
  $$CustomCardsTableTableManager(_$AppDatabase db, $CustomCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> text_ = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomCardsCompanion(
                id: id,
                gameId: gameId,
                categoryId: categoryId,
                text_: text_,
                intensity: intensity,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                remoteId: remoteId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required String categoryId,
                required String text_,
                Value<int> intensity = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomCardsCompanion.insert(
                id: id,
                gameId: gameId,
                categoryId: categoryId,
                text_: text_,
                intensity: intensity,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                remoteId: remoteId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomCardsTable, CustomCard>(table),
                  $$CustomCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.gameId,
                        referencedTable: $$CustomCardsTableReferences
                            ._gameIdTable(db),
                        referencedColumn: $$CustomCardsTableReferences
                            ._gameIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$CustomCardsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$CustomCardsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CustomCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomCardsTable,
      CustomCard,
      $$CustomCardsTableFilterComposer,
      $$CustomCardsTableOrderingComposer,
      $$CustomCardsTableAnnotationComposer,
      $$CustomCardsTableCreateCompanionBuilder,
      $$CustomCardsTableUpdateCompanionBuilder,
      (CustomCard, $$CustomCardsTableReferences),
      CustomCard,
      PrefetchHooks Function({bool gameId, bool categoryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$RuleSlidesTableTableManager get ruleSlides =>
      $$RuleSlidesTableTableManager(_db, _db.ruleSlides);
  $$BadgesTableTableManager get badges =>
      $$BadgesTableTableManager(_db, _db.badges);
  $$ContentAssetsTableTableManager get contentAssets =>
      $$ContentAssetsTableTableManager(_db, _db.contentAssets);
  $$ContentMetaTableTableManager get contentMeta =>
      $$ContentMetaTableTableManager(_db, _db.contentMeta);
  $$LocalPlayersTableTableManager get localPlayers =>
      $$LocalPlayersTableTableManager(_db, _db.localPlayers);
  $$GameSessionsTableTableManager get gameSessions =>
      $$GameSessionsTableTableManager(_db, _db.gameSessions);
  $$SessionPlayersTableTableManager get sessionPlayers =>
      $$SessionPlayersTableTableManager(_db, _db.sessionPlayers);
  $$AppPrefsTableTableManager get appPrefs =>
      $$AppPrefsTableTableManager(_db, _db.appPrefs);
  $$EarnedBadgesTableTableManager get earnedBadges =>
      $$EarnedBadgesTableTableManager(_db, _db.earnedBadges);
  $$CustomCardsTableTableManager get customCards =>
      $$CustomCardsTableTableManager(_db, _db.customCards);
}
