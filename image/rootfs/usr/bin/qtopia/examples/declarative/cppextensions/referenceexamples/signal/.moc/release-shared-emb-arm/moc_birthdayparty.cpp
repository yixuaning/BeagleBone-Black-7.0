/****************************************************************************
** Meta object code from reading C++ file 'birthdayparty.h'
**
** Created: Sun Mar 30 21:20:15 2014
**      by: The Qt Meta Object Compiler version 63 (Qt 4.8.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../birthdayparty.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'birthdayparty.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_BirthdayPartyAttached[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       1,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // properties: name, type, flags
      28,   22, 0x0e095103,

       0        // eod
};

static const char qt_meta_stringdata_BirthdayPartyAttached[] = {
    "BirthdayPartyAttached\0QDate\0rsvp\0"
};

void BirthdayPartyAttached::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    Q_UNUSED(_o);
    Q_UNUSED(_id);
    Q_UNUSED(_c);
    Q_UNUSED(_a);
}

const QMetaObjectExtraData BirthdayPartyAttached::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject BirthdayPartyAttached::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_BirthdayPartyAttached,
      qt_meta_data_BirthdayPartyAttached, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &BirthdayPartyAttached::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *BirthdayPartyAttached::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *BirthdayPartyAttached::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_BirthdayPartyAttached))
        return static_cast<void*>(const_cast< BirthdayPartyAttached*>(this));
    return QObject::qt_metacast(_clname);
}

int BirthdayPartyAttached::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    
#ifndef QT_NO_PROPERTIES
     if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QDate*>(_v) = rsvp(); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setRsvp(*reinterpret_cast< QDate*>(_v)); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 1;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}
static const uint qt_meta_data_BirthdayParty[] = {

 // content:
       6,       // revision
       0,       // classname
       1,   14, // classinfo
       1,   16, // methods
       2,   21, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // classinfo: key, value
      21,   14,

 // signals: signature, parameters, type, tag, flags
      43,   38,   37,   37, 0x05,

 // properties: name, type, flags
      71,   63, 0x0009510b,
      14,   76, 0x00095009,

       0        // eod
};

static const char qt_meta_stringdata_BirthdayParty[] = {
    "BirthdayParty\0guests\0DefaultProperty\0"
    "\0time\0partyStarted(QTime)\0Person*\0"
    "host\0QDeclarativeListProperty<Person>\0"
};

void BirthdayParty::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        BirthdayParty *_t = static_cast<BirthdayParty *>(_o);
        switch (_id) {
        case 0: _t->partyStarted((*reinterpret_cast< const QTime(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData BirthdayParty::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject BirthdayParty::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_BirthdayParty,
      qt_meta_data_BirthdayParty, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &BirthdayParty::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *BirthdayParty::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *BirthdayParty::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_BirthdayParty))
        return static_cast<void*>(const_cast< BirthdayParty*>(this));
    return QObject::qt_metacast(_clname);
}

int BirthdayParty::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 1)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< Person**>(_v) = host(); break;
        case 1: *reinterpret_cast< QDeclarativeListProperty<Person>*>(_v) = guests(); break;
        }
        _id -= 2;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setHost(*reinterpret_cast< Person**>(_v)); break;
        }
        _id -= 2;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 2;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 2;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void BirthdayParty::partyStarted(const QTime & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE
