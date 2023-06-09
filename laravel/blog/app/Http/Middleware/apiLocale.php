<?php

namespace App\Http\Middleware;

use Closure;
use App;

class apiLocale
{
    public function handle($request, Closure $next)
    {
        if (request()->header('lang')) {
            App::setLocale(request()->header('lang'));
        } else {
            App::setLocale('en');
        }
        return $next($request);
    }
}
