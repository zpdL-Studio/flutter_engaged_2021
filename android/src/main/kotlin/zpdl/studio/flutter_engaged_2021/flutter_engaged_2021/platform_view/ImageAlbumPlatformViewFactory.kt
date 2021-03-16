package zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.platform_view

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.FlutterEngaged2021Plugin

/** CameraPlatformViewFactory */
class ImageAlbumPlatformViewFactory(private val messenger: BinaryMessenger, private val permission: ImageAlbumPlatformViewPermission) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  companion object {
    const val CHANNEL = "${FlutterEngaged2021Plugin.CHANNEL}_platform_view"
  }

  override fun create(context: Context?, viewId: Int, args: Any?): PlatformView = CameraPlatformView(messenger, permission, context!!, viewId, args)
}

enum class FlutterMethod(val method: String) {
    ON_PLUGIN_IMAGE("${ImageAlbumPlatformViewFactory.CHANNEL}/ON_PLUGIN_IMAGE")
}