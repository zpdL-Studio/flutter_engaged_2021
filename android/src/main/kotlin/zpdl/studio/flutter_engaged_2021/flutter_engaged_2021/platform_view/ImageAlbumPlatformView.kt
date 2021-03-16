package zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.platform_view

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.platform.PlatformView
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.PluginImage

/** SelluryCameraPlugin */
class CameraPlatformView(
        messenger: BinaryMessenger,
        pluginPermission: ImageAlbumPlatformViewPermission,
        context: Context,
        viewId: Int,
        @Suppress("UNUSED_PARAMETER") args: Any?) : PlatformView, MethodCallHandler {

  private val methodChannel = MethodChannel(messenger, "${ImageAlbumPlatformViewFactory.CHANNEL}_$viewId").apply {
    setMethodCallHandler(this@CameraPlatformView)
  }

  private val view: ImageAlbumView = ImageAlbumView(context).apply {
    setOnListener(object : ImageAlbumViewListener {
      override fun onPluginImage(image: PluginImage) {
        methodChannel.invokeMethod(FlutterMethod.ON_PLUGIN_IMAGE.method, image.toMap())
      }
    })
  }

  init {
    pluginPermission.onRequestPermission { 
      view.init()
    }
  }

  override fun getView(): View = view

  override fun dispose() {
    methodChannel.setMethodCallHandler(null)
    view.setOnListener(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    result.notImplemented()
  }
}

interface ImageAlbumViewListener {
  fun onPluginImage(image: PluginImage)
}

interface ImageAlbumPlatformViewPermission {
  fun onRequestPermission(results: () -> Unit)
}


