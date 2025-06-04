> Tip: Render *.md files locally with Chrome browser http://stackoverflow.com/a/15626336

# QML Style Guide by 219 Design, LLC

Guidelines that are auto-enforced:
----------------------------------

There are quite a few guidelines that we do not need to describe here at all,
thanks to the fact that we have two key pieces of automated enforcement:

 - `tools/formatters/enforce_qml_format.sh`
 - `tools/gui_test/check_gui_test_log.py`

`enforce_qml_format.sh` takes care of all whitespace issues in our QML.

`check_gui_test_log.py` ensures that nothing in our QML provokes any of the most
common signs of accidental coding mistakes. Specifically, it ensures that when
launching the app we are free from the common `ReferenceError` and `Unable to
assign undefined` QML errors.

These automated enforcers save us a lot of tedious "by hand" inspection for many
common typos and refactoring mistakes.

Proper QML Habits:
------------------

### root-id ###

When defining a custom Object Type in a QML File, it is customary to make `id:
root` be the first property of your outermost scope/braces. (Don't worry. Having
many files that all use `id: root` will not cause naming collisions, because of
how "Component scope" works.)

--------------------------------------------------------------------------------
### private-property ###

If you wish to declare properties on your type that are NOT INTENDED for use by
users of your type, then declare them with a trailing underscore, like so:

```
Item {
  id: root

  readonly property int privateConstThing_: 20
  property string privateThing_: "other"
```

This is only a convention! No access protection is guaranteed here.

Note: we avoid attempts to use a leading (prefix) underscore, because that
inteferes with the QML feature of capitalizing a property and prepending `on` to
create slots such as `onVisibleChanged`.

**Bonus:**

If you do require strong access protection that none of the users of your type
can circumvent, then you need the proverbial "extra level of indirection" that
(per the unscientific "fundamental theorem of software engineering") solves
every problem in computer science.  It looks like this:

```
Item {
  id: root
  QtObject {
    id: p
    property string veryPrivateThing: "other"
  }
  property string publicThing: "public"
  property string hereWeCanUseIt: p.veryPrivateThing
}
```

Users of your type can access `publicThing`. However, they will be unsuccessful
at any attempt to access `p` or `p.veryPrivateThing`.  Meanwhile (as shown by
`hereWeCanUseIt`), your own type inside your file is still able to access
`p.veryPrivateThing`.

--------------------------------------------------------------------------------
### anchor-at-instantiation ###

When defining a custom type in a QML file, AVOID using any of {height,
width, anchors, x, y} at the outermost scope/braces!

```
Item {  // THIS CODE SNIPPET USES A *BAD* PATTERN
  id: root

  anchors.fill: parent //  NO NO NO NO!!  DO NOT PUT THIS IN YOUR ROOT ITEM.
```

Those types of sizing decisions should ALWAYS be left up to the user (aka at the
instantiation site).

However, for ease-of-use with `qmlscene`, we allow an exception, but remember to
clearly label it with a comment:

```
Item {
  id: root

  // The app may override, but leave (height,width) here for qmlscene
  height: 250
  width: 100
```

--------------------------------------------------------------------------------
### empty ###

It is sometimes useful to use "empty items" in layouts in order to specify a
"stretchable spacer" element between two non-empty items. (This is not
exhaustive. There may be other times that an "empty item" is useful.) However,
if the height and width of an item are both ZERO, then QML often refuses to
acknowledge your empty item's presence (and purpose) at all. When it is
necessary to avoid a ZERO size, we adopt the convention of always using `1`.

A comment that the item is a spacer, while optional, is helpful for reviewers.

```
        Item {
          // this is a 'spacer' to force other items to the outer edges
          Layout.fillWidth: true
          height: 1    // prefer 1 so that we don't get a mix of 5, 10, 2, etc.
        }
```

--------------------------------------------------------------------------------
### themes ###

Try to AVOID putting any color literals or font-size literals in the
code. Always use some kind of `Theme` singleton instead.

DO NOT:
```
  color: 'green'   // BAD IDEA.
```

PLEASE USE A THEME:
```
  color: Theme.secondaryColorMediumDark  // GOOD!
```

--------------------------------------------------------------------------------
### layouts ###

When using `QtQuick.Layouts`, pay careful attention to which things are direct
children of the layout, and which things are NOT. Also remember that the Layout
itself (be it a `RowLayout`, or a `GridLayout`, or other) is usually NOT a child
of a layout. A layout *can be* nested as a child of another layout, but in the
"common case" it probably isn't. Either way, pay close attention as you review
each item in your hierarchy and see if it is a direct layout child or not.

Once you have discerned whether an item is a direct-child of a layout or not,
here are some guidelines:

 - If it is NOT a direct-child, position with the usual `anchors` tactics.

Otherwise:

 - If it is a direct-child, AVOID `anchors` and also AVOID the plain properties
   `height` and `width`. Instead, ALL sizing/positioning properties you use
   should begin with `Layout.*`

Putting the above bits of advice together, we get:

```
Item {
    id: root
    ColumnLayout {
        id: mainLayout
        anchors.fill: parent // YES. use anchors. this item is not itself in a layout.
        anchors.margins: margin
        GroupBox {
            id: rowBox
            title: "Row layout"
            Layout.fillWidth: true  // YES. this is a direct-child of layout. use Layout.* properties
            Layout.fillWidth: true

```

Putting the above bits of advice together in a more deeply-nested scenario, we
get:

```
Item {
  id: root

  ColumnLayout {
    id: mainContent
    anchors.fill: parent  // YES. use anchors here.

      RowLayout {
        id: firstRow
        Layout.fillWidth: true    // direct-child of the ColumnLayout, so use Layout.* properties
        Layout.minimumHeight: firstRow.rowHeight_
        readonly property int rowHeight_: 55

        Item {
          Layout.minimumWidth: mainContent.width * .45    // direct-child of the RowLayout, so use Layout.* properties
          Layout.minimumHeight: firstRow.rowHeight_
          Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter

          StyledTabBar {
            width: parent.width             // ah ha! this is a direct-child of an Item (not a layout!)
            anchors.bottom: parent.bottom   // YES. so we use plain anchors and (optionally) plain width here.
```

Extra help:

 - https://doc.qt.io/qt-5/qtquick-layouts-example.html
 - https://code.qt.io/cgit/qt/qtdeclarative.git/tree/examples/quick/layouts

--------------------------------------------------------------------------------
### capitalization ###

Sometimes it becomes fashionable for a design to feature ALL_CAPS text (such as
showing "OPEN" on a button instead of "Open"). When working on such designs,
prefer to apply ALL_CAPS by using QML's built-in `font.capitalization` property
and setting it to `Font.AllUppercase`. This will alleviate the need to remember
to TYPE OUR UI STRINGS IN ALL CAPS (which is exhausting).

--------------------------------------------------------------------------------
### instantiation-properties ###

All properties that are user-accessible at the instantiation site should be
placed directly underneath the id of the Item encapsulating the type, like so:

```
//Add your imports here
...
Item {
  id: root

  property int firstInstantiationProperty: 0
  property var secondInstantionProperty: "hello"

  //rest of the qml file
}
```
Don't sprinkle them throughout the file.

--------------------------------------------------------------------------------
