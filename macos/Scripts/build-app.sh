#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MACOS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST_DIR="$MACOS_DIR/dist"
APP_NAME="Tiny11Builder"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
DMG_PATH="$DIST_DIR/${APP_NAME}-macOS-arm64.dmg"
VERSION="${TINY11_MAC_VERSION:-0.2.0}"

echo "==> [1/6] Ensuring Homebrew build dependencies..."
"$SCRIPT_DIR/setup-dev-deps.sh"

echo "==> [2/6] Building Release arm64 binary via SwiftPM..."
swift build --package-path "$MACOS_DIR" -c release --arch arm64
BIN_DIR="$(swift build --package-path "$MACOS_DIR" -c release --arch arm64 --show-bin-path)"
BUILT_EXEC="$BIN_DIR/Tiny11BuilderMac"

if [ ! -f "$BUILT_EXEC" ]; then
    echo "Error: Expected executable not found at $BUILT_EXEC" >&2
    exit 1
fi

echo "==> [3/6] Assembling $APP_NAME.app bundle structure..."
rm -rf "$APP_BUNDLE" "$DMG_PATH"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Frameworks"
mkdir -p "$APP_BUNDLE/Contents/Resources/bin"

cp "$BUILT_EXEC" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
chmod 755 "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

# Generate AppIcon.icns programmatically using AppKit + iconutil
ICON_WORK="$(mktemp -d)"
ICONSET_DIR="$ICON_WORK/AppIcon.iconset"
mkdir -p "$ICONSET_DIR"
swift - "$ICONSET_DIR" <<'SWIFT_ICON'
import AppKit
let outDir = URL(fileURLWithPath: CommandLine.arguments[1])
let specs: [(String, Int)] = [
    ("icon_16x16.png", 16), ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32), ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128), ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256), ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512), ("icon_512x512@2x.png", 1024)
]
for (name, px) in specs {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: px, pixelsHigh: px,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    )!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    let rect = NSRect(x: 0, y: 0, width: px, height: px)
    let inset = CGFloat(px) * 0.08
    let card = rect.insetBy(dx: inset, dy: inset)
    let radius = CGFloat(px) * 0.22
    let path = NSBezierPath(roundedRect: card, xRadius: radius, yRadius: radius)
    let grad = NSGradient(colors: [
        NSColor(calibratedRed: 0.07, green: 0.42, blue: 0.92, alpha: 1.0),
        NSColor(calibratedRed: 0.04, green: 0.20, blue: 0.56, alpha: 1.0)
    ])!
    grad.draw(in: path, angle: -55)

    // Draw stylized 4-pane window + disc ring
    let ringRect = card.insetBy(dx: card.width * 0.20, dy: card.height * 0.20)
    let ring = NSBezierPath(ovalIn: ringRect)
    ring.lineWidth = max(1.5, CGFloat(px) * 0.045)
    NSColor.white.withAlphaComponent(0.92).setStroke()
    ring.stroke()

    let holeRect = card.insetBy(dx: card.width * 0.41, dy: card.height * 0.41)
    NSColor.white.withAlphaComponent(0.95).setFill()
    NSBezierPath(ovalIn: holeRect).fill()
    NSGraphicsContext.restoreGraphicsState()

    if let png = rep.representation(using: .png, properties: [:]) {
        try png.write(to: outDir.appendingPathComponent(name))
    }
}
SWIFT_ICON
iconutil -c icns "$ICONSET_DIR" -o "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
rm -rf "$ICON_WORK"

cat > "$APP_BUNDLE/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleDisplayName</key>
    <string>Tiny11 Builder</string>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.tiny11builder.mac</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Tiny11 Builder</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.developer-tools</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "==> [4/6] Bundling native tools and relocating dynamic libraries..."
WIMLIB_PREFIX="$(brew --prefix wimlib)"
CDRTOOLS_PREFIX="$(brew --prefix cdrtools)"
HIVEX_PREFIX="$(brew --prefix hivex)"
GETTEXT_PREFIX="$(brew --prefix gettext)"

cp -L "$WIMLIB_PREFIX/bin/wimlib-imagex" "$APP_BUNDLE/Contents/Resources/bin/wimlib-imagex"
cp -L "$CDRTOOLS_PREFIX/bin/mkisofs" "$APP_BUNDLE/Contents/Resources/bin/mkisofs"
cp -L "$WIMLIB_PREFIX/lib/libwim.15.dylib" "$APP_BUNDLE/Contents/Frameworks/libwim.15.dylib"
cp -L "$HIVEX_PREFIX/lib/libhivex.0.dylib" "$APP_BUNDLE/Contents/Frameworks/libhivex.0.dylib"
cp -L "$GETTEXT_PREFIX/lib/libintl.8.dylib" "$APP_BUNDLE/Contents/Frameworks/libintl.8.dylib"

chmod 755 "$APP_BUNDLE/Contents/Resources/bin/"* "$APP_BUNDLE/Contents/Frameworks/"*.dylib

# Rewrite install names & dependency paths so zero /opt/homebrew references remain
install_name_tool -id "@rpath/libwim.15.dylib" "$APP_BUNDLE/Contents/Frameworks/libwim.15.dylib"
install_name_tool -id "@rpath/libhivex.0.dylib" "$APP_BUNDLE/Contents/Frameworks/libhivex.0.dylib"
install_name_tool -id "@loader_path/libintl.8.dylib" "$APP_BUNDLE/Contents/Frameworks/libintl.8.dylib"

# Update libhivex -> libintl
OLD_INTL="$(otool -L "$APP_BUNDLE/Contents/Frameworks/libhivex.0.dylib" | awk '/libintl/ {print $1}')"
if [ -n "$OLD_INTL" ]; then
    install_name_tool -change "$OLD_INTL" "@loader_path/libintl.8.dylib" "$APP_BUNDLE/Contents/Frameworks/libhivex.0.dylib"
fi

# Update wimlib-imagex -> libwim
OLD_WIM="$(otool -L "$APP_BUNDLE/Contents/Resources/bin/wimlib-imagex" | awk '/libwim/ {print $1}')"
if [ -n "$OLD_WIM" ]; then
    install_name_tool -change "$OLD_WIM" "@executable_path/../../Frameworks/libwim.15.dylib" "$APP_BUNDLE/Contents/Resources/bin/wimlib-imagex"
fi

# Update main app executable -> libhivex and strip dev Homebrew rpath
OLD_HIVEX="$(otool -L "$APP_BUNDLE/Contents/MacOS/$APP_NAME" | awk '/libhivex/ {print $1}')"
if [ -n "$OLD_HIVEX" ]; then
    install_name_tool -change "$OLD_HIVEX" "@executable_path/../Frameworks/libhivex.0.dylib" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
fi
install_name_tool -delete_rpath "/opt/homebrew/opt/hivex/lib" "$APP_BUNDLE/Contents/MacOS/$APP_NAME" 2>/dev/null || true

cat > "$APP_BUNDLE/Contents/Resources/THIRD_PARTY_NOTICES.txt" <<'EOF'
Tiny11 Builder for Mac bundles unmodified open-source native utilities:
- wimlib / libwim (GPL-3.0-or-later): https://wimlib.net/
- libhivex (LGPL-2.1-only): https://libguestfs.org/
- cdrtools / mkisofs (CDDL-1.0): https://codeberg.org/schilytools/schilytools
- GNU gettext libintl (LGPL-2.1-or-later): https://www.gnu.org/software/gettext/
EOF

echo "==> [5/6] Signing bundle and auditing zero external dylib leaks..."
for dylib in "$APP_BUNDLE/Contents/Frameworks/"*.dylib; do
    codesign --force --sign - "$dylib"
done
for tool in "$APP_BUNDLE/Contents/Resources/bin/"*; do
    codesign --force --sign - "$tool"
done
codesign --force --deep --sign - "$APP_BUNDLE"
codesign --verify --deep --strict "$APP_BUNDLE"

# Audit every Mach-O inside the app bundle for stray /opt/homebrew or /usr/local paths
LEAKS=0
for macho in \
    "$APP_BUNDLE/Contents/MacOS/$APP_NAME" \
    "$APP_BUNDLE/Contents/Resources/bin/wimlib-imagex" \
    "$APP_BUNDLE/Contents/Resources/bin/mkisofs" \
    "$APP_BUNDLE/Contents/Frameworks/"*.dylib; do
    if otool -L "$macho" | tail -n +2 | grep -E "(/opt/homebrew|/usr/local)" >/dev/null; then
        echo "ERROR: External library leak detected in $macho:" >&2
        otool -L "$macho" >&2
        LEAKS=1
    fi
    if otool -l "$macho" | grep -A2 LC_RPATH | grep -E "(/opt/homebrew|/usr/local)" >/dev/null; then
        echo "ERROR: External LC_RPATH leak detected in $macho" >&2
        LEAKS=1
    fi
done
if [ "$LEAKS" -ne 0 ]; then
    exit 1
fi
echo "  ✔ Zero external library leaks! Self-contained bundle verified."

echo "==> [6/6] Packaging $DMG_PATH..."
DMG_STAGE="$(mktemp -d)"
cp -R "$APP_BUNDLE" "$DMG_STAGE/"
ln -s /Applications "$DMG_STAGE/Applications"
hdiutil create -volname "Tiny11 Builder" -srcfolder "$DMG_STAGE" -ov -format UDZO "$DMG_PATH" >/dev/null
rm -rf "$DMG_STAGE"

echo ""
echo "=========================================================="
echo "Build Complete!"
echo "  App Bundle : $APP_BUNDLE"
echo "  Disk Image : $DMG_PATH ($(du -h "$DMG_PATH" | awk '{print $1}'))"
echo "=========================================================="
