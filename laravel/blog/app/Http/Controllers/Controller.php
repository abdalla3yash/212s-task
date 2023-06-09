<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    # --------------------successResponse------------------
    public function successResponse($data, $message = NULL)
    {
        $response = array(
            'status'  => TRUE,
            'message' => $message,
            'data'    => $data
        );
        return response()->json($response, 200);
    }


    # --------------------errorResponse------------------
    public function errorResponse($errors , $data = NULL)
    {
        $response = array(
            'status'  => FALSE,
            'message' => $errors,
            'data'    => $data
        );
        return response()->json($response);
    }

    #------------------ format error----------------
    public function formatErrors($errors)
    {
        $stringError = "";
        for ($i=0; $i < count($errors->all()); $i++) {
            $stringError = $stringError . $errors->all()[$i];
            if($i != count($errors->all())-1){
                $stringError = $stringError . '\n';
            }
        }
        return $stringError;
    }
}
