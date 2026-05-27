package com.example.ruta_segura

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Actividad principal de la aplicación en Android.
 * Extiende de FlutterActivity para permitir la comunicación entre el código
 * Dart (Flutter) y el código nativo de Android (Kotlin) mediante MethodChannels.
 */
class MainActivity : FlutterActivity() {
    private val CHANNEL_LLAMADA = "com.tuapp/llamada"

    /**
     * Configura el motor de Flutter y establece los "puentes" (MethodChannels)
     * para escuchar las peticiones que vienen desde Dart.
     */
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Configuración del canal para realizar llamadas telefónicas nativas
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_LLAMADA)
            .setMethodCallHandler { call, result ->
                if (call.method == "hacerLlamada") {
                    val numero = call.argument<String>("numero")
                    val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:$numero"))
                    startActivity(intent)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
