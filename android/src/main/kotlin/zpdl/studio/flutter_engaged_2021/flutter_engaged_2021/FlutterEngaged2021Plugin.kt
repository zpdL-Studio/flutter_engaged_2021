package zpdl.studio.flutter_engaged_2021.flutter_engaged_2021

import android.content.Intent
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import zpdl.studio.flutter_engaged_2021.flutter_engaged_2021.activity.ImageAlbumActivity

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

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(Method.from(call.method)) {
      Method.GET_IMAGE_FOLDER -> {
        activityPluginBinding?.activity?.let {
          it.startActivity(Intent(it, ImageAlbumActivity::class.java))
        }
        result.success(null)
      }
      null -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    activityPluginBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityPluginBinding = null
  }
}

enum class Method(val method: String) {
  GET_IMAGE_FOLDER("${FlutterEngaged2021Plugin.CHANNEL}/SHOW_IMAGE_ALBUM"),
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