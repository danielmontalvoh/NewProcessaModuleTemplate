function Set-Configuration {
<#
.SYNOPSIS
Establece la información de los datos de configuración del módulo.

.DESCRIPTION
Establece la información de los datos de configuración del módulo en el archivo <%=$PLASTER_PARAM_ModuleName%>..config. **Se requiere que el usuario tenga permisos de Administrador**.

.EXAMPLE
Set-Configuration
Muestra una ventana que permite al administrador establecer los valores de configuración.

.INPUTS
Ninguno
Esta función no acepta parámetros a través de la canalización,

.LINK
[Test-Configuration](Test-Configuration.md)

.LINK
[Get-Configuration](Get-Configuration.md)

.NOTES
Autor: <%=$PLASTER_PARAM_ModuleAuthor%>
#>
    [CmdletBinding()]
    [OutputType([System.Void])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    Param()

    try {
        $InformationAction = $PSBoundParameters | Get-DictionaryKey -Key 'InformationAction' -DefaultValue 'Continue'

		# Agregue sus valores de configuración y quite los "dummy"
        $ConfigInfo = @(
            New-ConfigurationItem -Type 'ConnectionString' -ConfigKey 'Sql:Local' -FriendlyName 'SqlLocal' -DataType 'String' -Description 'Mi servidor de Sql Server' -Category 'Cadenas de conexión' -DefaultIfNullOrEmpty 'Server=(local);Database=master;Trusted_Connection=True;'
            New-ConfigurationItem -Type 'AppSetting' -ConfigKey 'MyKey' -FriendlyName 'UnValor' -DataType 'String' -Description 'Ingrese un valor cualquiera' -Category 'Configuraciones generales' -DefaultIfNullOrEmpty '123'
        )

        if (Set-ConfigurationFile -Path $Script:AppConfig -ConfigurationInfo $ConfigInfo) {
            $ConfigInfo | Out-String | Write-Verbose
            Write-Information -MessageData 'Starting testing phase...' -InformationAction $InformationAction
            Initialize-Database
            $Script:ConfigurationCache = $null
            Test-Configuration -SaveFlag
        }
    }
    catch {
        Write-Log -ErrorRecord $PSItem
        throw
    }
    finally{
        $Script:ConfigurationCache = $null
    }
}
