package com.example.ruta_segura

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.content.Context
import android.net.Uri
import androidx.core.app.ActivityCompat
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
    private val CHANNEL_UBICACION = "com.tuapp/ubicacion"
    private val PERMISO_UBICACION = 101
    private var pendingResult: MethodChannel.Result? = null

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

        // Configuración del canal para obtener la ubicación GPS nativa
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_UBICACION)
            .setMethodCallHandler { call, result ->
                if (call.method == "obtenerUbicacion") {
                    val tienePermiso = ActivityCompat.checkSelfPermission(
                        this, Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED

                    if (tienePermiso) {
                        obtenerYResponder(result)
                    } else {
                        // Si no hay permisos, guardamos la petición y le mostramos el diálogo al usuario
                        pendingResult = result
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                            PERMISO_UBICACION
                        )
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    /**
     * Callback nativo de Android que se ejecuta automáticamente cuando el usuario
     * presiona "Permitir" o "Denegar" en el cuadro de diálogo de permisos.
     * Si acepta, continuamos con la obtención de la ubicación.
     */

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISO_UBICACION) {
            val resultado = pendingResult
            pendingResult = null
            if (resultado == null) return

            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                obtenerYResponder(resultado)
            } else {
                resultado.error("PERMISO_DENEGADO", "El usuario denegó el permiso de ubicación", null)
            }
        }
    }

    /**
     * Intenta obtener la última ubicación conocida del dispositivo consultando
     * los proveedores de GPS y Red. Es muy rápido porque lee la "caché" del celular.
     * Si no hay ubicación en caché, solicita una "ubicación fresca" encendiendo
     * el sensor GPS.
     */

    private fun obtenerYResponder(result: MethodChannel.Result) {
        try {
            val lm = getSystemService(Context.LOCATION_SERVICE) as LocationManager
            val proveedores = listOf(
                LocationManager.GPS_PROVIDER,
                LocationManager.NETWORK_PROVIDER
            )

            var ubicacion: android.location.Location? = null
            for (proveedor in proveedores) {
                try {
                    @Suppress("MissingPermission")
                    val loc = lm.getLastKnownLocation(proveedor)
                    if (loc != null) {
                        ubicacion = loc
                        break
                    }
                } catch (_: Exception) {}
            }

            if (ubicacion != null) {
                result.success(mapOf(
                    "lat" to ubicacion.latitude.toDouble(),
                    "lng" to ubicacion.longitude.toDouble()
                ))
            } else {
                // El GPS está encendido pero no tiene historial reciente,
                // forzamos al sensor a buscar los satélites ahora mismo.
                obtenerUbicacionFresca(result)
            }
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    /**
     * Enciende el sensor GPS de Android para obtener exactamente un (1) solo reporte
     * de ubicación actualizado, y lo envía de regreso a Flutter.
     */

    private fun obtenerUbicacionFresca(result: MethodChannel.Result) {
        try {
            val lm = getSystemService(Context.LOCATION_SERVICE) as LocationManager
            @Suppress("MissingPermission")
            lm.requestSingleUpdate(
                LocationManager.GPS_PROVIDER,
                { location ->
                    result.success(mapOf(
                        "lat" to location.latitude.toDouble(),
                        "lng" to location.longitude.toDouble()
                    ))
                },
                mainLooper
            )
        } catch (e: Exception) {
            result.error("SIN_UBICACION", "GPS activo pero sin señal aún. Intenta en exterior.", null)
        }
    }
}