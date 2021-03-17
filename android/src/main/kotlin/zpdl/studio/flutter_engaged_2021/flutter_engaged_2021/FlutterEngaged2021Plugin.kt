package zpdl.studio.flutter_engaged_2021.flutter_engaged_2021

import android.Manifest
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.activity.ImageAlbumActivity
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.platform_view.ImageAlbumPlatformViewFactory
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.platform_view.ImageAlbumPlatformViewPermission

/** FlutterEngaged2021Plugin */
class FlutterEngaged2021Plugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  companion object {
    const val CHANNEL = "flutter_engaged_2021"
  }
  
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activityPluginBinding: ActivityPluginBinding? = null

  private var platformViewPermissionResult: (() -> Unit)? = null
  private val platformViewPermissionsResultListener = PluginRegistry.RequestPermissionsResultListener { requestCode, permissions, grantResults ->
    if(requestCode == 0x00) {
      platformViewPermissionResult?.let { it() }
      return@RequestPermissionsResultListener true
    }
    return@RequestPermissionsResultListener false
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)

    flutterPluginBinding.platformViewRegistry.registerViewFactory(
            ImageAlbumPlatformViewFactory.CHANNEL,
            ImageAlbumPlatformViewFactory(flutterPluginBinding.binaryMessenger, object : ImageAlbumPlatformViewPermission {
              override fun onRequestPermission(results: () -> Unit) {
                platformViewPermissionResult = results
                activityPluginBinding?.activity?.requestPermissions(arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE), 0x00)
              }
            }))
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(Method.from(call.method)) {
      Method.SHOW_IMAGE_ALBUM -> {
        activityPluginBinding?.activity?.let {
          it.startActivity(Intent(it, ImageAlbumActivity::class.java))
        }
        result.success(null)
      }
      Method.GET_IMAGES -> {
        CoroutineScope(Dispatchers.Main).launch {
          val results = mutableListOf<Map<String, *>>()
          CoroutineScope(Dispatchers.Default).async {
            val images = ImageQuery.getImages(activityPluginBinding?.activity)
            for(image in images) {
              results.add(image.toMap())
            }
          }.await()
          result.success(results)
        }
      }
      Method.READ_IMAGE_BYTES -> {
        var byteArray: ByteArray? = null
        if(call.arguments is String) {
          (call.arguments as String).toLongOrNull()?.let { id ->
            activityPluginBinding?.activity?.let {
              byteArray = ImageQuery.readBytes(it, id)
            }
          }
        }
        result.success(byteArray)
      }
      Method.GET_THUMBNAIL_BITMAP -> {
        var pluginBitmap: PluginBitmap? = null
        if(call.arguments is String) {
          (call.arguments as String).toLongOrNull()?.let { id ->
            activityPluginBinding?.activity?.let { activity ->
              ImageQuery.getThumbnail(activity, id)?.let {
                pluginBitmap = PluginBitmap.createARGB(it)
              }
            }
          }
        }
        result.success(pluginBitmap?.toMap())
      }
      null -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    activityPluginBinding?.removeRequestPermissionsResultListener(platformViewPermissionsResultListener)
    activityPluginBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
    activityPluginBinding?.addRequestPermissionsResultListener(platformViewPermissionsResultListener)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
    activityPluginBinding?.addRequestPermissionsResultListener(platformViewPermissionsResultListener)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityPluginBinding?.removeRequestPermissionsResultListener(platformViewPermissionsResultListener)
    activityPluginBinding = null
  }
}

enum class Method(val method: String) {
  SHOW_IMAGE_ALBUM("${FlutterEngaged2021Plugin.CHANNEL}/SHOW_IMAGE_ALBUM"),
  GET_IMAGES("${FlutterEngaged2021Plugin.CHANNEL}/GET_IMAGES"),
  READ_IMAGE_BYTES("${FlutterEngaged2021Plugin.CHANNEL}/READ_IMAGE_BYTES"),
  GET_THUMBNAIL_BITMAP("${FlutterEngaged2021Plugin.CHANNEL}/GET_THUMBNAIL_BITMAP"),
  ;

  companion object {
    fun from(method: String): Method? {
      for(value in values()) {
        if(value.method == method) {
          return value
        }
      }
      return null
    }
  }
}