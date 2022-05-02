#include <QMetaType>
#include <QQmlEngine>

// Internal helper function that registers a type with modifier (like being wrapped in a vector).
// aliases is the list of aliased names the underlying class uses, and aliasModifierOrNone is optionally a function that will apply the modifier to the alias.
template <typename ModifiedType>
void registerModifiedType(
    const std::vector<std::string>& aliases, std::function<std::string( const std::string& )> aliasModifier = []( const std::string& s ) { return s; } )
{
    if( aliases.size() == 0 )
    {
        qRegisterMetaType<ModifiedType>();
    }
    else
    {
        for( const std::string& alias : aliases )
        {
            qRegisterMetaType<ModifiedType>( aliasModifier( alias ).c_str() );
        }
    }
}

// Aliases is all aliases that will be registered for the type (such as both type name with and without the namespace).
// If the type is not anonymous, the first alias will be used as the name.
// It is valid to register a type without aliases, but then it must be anonymous.
// Template arguments control which variants on a type (pointer, Qt smart pointer, etc.) are created, as well as const versions (with const-ness binding most tightly to the main type).
template <typename TypeWithoutQualifiers, bool makeAnonymous, bool registerConstVersions, bool registerValueType, bool registerPointer, bool registerSharedPointer, bool registerVectorOfSharedPointers>
void registerType( const std::vector<std::string>& aliases )
{
    if constexpr( makeAnonymous )
    {
        qmlRegisterAnonymousType<TypeWithoutQualifiers>( "App", 1 );
    }
    else
    {
        qmlRegisterType<TypeWithoutQualifiers>( "App", 1, 0, aliases[ 0 ].c_str() );
    }

    if constexpr( registerValueType )
    {
        registerModifiedType<TypeWithoutQualifiers>( aliases );
        if constexpr( registerConstVersions )
        {
            registerModifiedType<const TypeWithoutQualifiers>( aliases, []( const std::string& s ) { return "const " + s; } );
        }
    }
    if constexpr( registerPointer )
    {
        registerModifiedType<TypeWithoutQualifiers*>( aliases, []( const std::string& s ) { return s + "*"; } );
        if constexpr( registerConstVersions )
        {
            registerModifiedType<const TypeWithoutQualifiers*>( aliases, []( const std::string& s ) { return "const " + s + "*"; } );
        }
    }
    if constexpr( registerSharedPointer )
    {
        registerModifiedType<QSharedPointer<TypeWithoutQualifiers>>( aliases, []( const std::string& s ) { return "QSharedPointer<" + s + ">"; } );
        if constexpr( registerConstVersions )
        {
            registerModifiedType<QSharedPointer<const TypeWithoutQualifiers>>( aliases, []( const std::string& s ) { return "QSharedPointer<const " + s + ">"; } );
        }
    }
    if constexpr( registerVectorOfSharedPointers )
    {
        registerModifiedType<QVector<QSharedPointer<TypeWithoutQualifiers>>>( aliases, []( const std::string& s ) { return "QVector<QSharedPointer<" + s + ">>"; } );
        if constexpr( registerConstVersions )
        {
            registerModifiedType<QVector<QSharedPointer<const TypeWithoutQualifiers>>>( aliases, []( const std::string& s ) { return "QVector<QSharedPointer<const " + s + ">>"; } );
        }
    }
}
