using System.Diagnostics;
using System.Reflection;
using Pondhawk.Rules;
using Spectre.Console;

namespace Pondhawk.Migrations;

public static class UiHelper
{

    private static readonly Stopwatch TheStopWatch = new();
    private static bool _quiet;
    
    public static void ShowHeader()
    {

        try
        {
            AnsiConsole.Clear();
        }
        catch
        {
            // ignore
        }

        AnsiConsole.MarkupLine("[silver]Pondhawk One Migrations CLI[/]");
        AnsiConsole.MarkupLine("[silver]Pond Hawk Technologies Inc. (c) 2025[/]");
        AnsiConsole.WriteLine();
        AnsiConsole.WriteLine();        
        
    }


    public static void BeQuiet()
    {
        _quiet = true;   
    }
    
    private static long _startTime;
    public static void Start()
    {
        _startTime = Stopwatch.GetTimestamp();       
        TheStopWatch.Start();
    }
    
    public static void Stop()
    {
        TheStopWatch.Stop();
    }

    public static void ShowOptions( string title, object source )
    {

        if(_quiet)
            return;
        
        var options = new Dictionary<string, object>();

        foreach (var property in source.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {

            if( !property.CanRead ) 
                continue;
            
            var v = property.GetValue(source);
            if( v is null ) 
                continue;

            options.Add(property.Name, v);
            
        }

        
        var headers = "silver";
        var label = "white";
        var value = "dodgerblue1";
        
        var table = new Table
        {
            Title = new TableTitle(title),
            Border = TableBorder.Rounded,
            BorderStyle = new Style(Color.Silver)
        };
        
        table.AddColumn(new TableColumn($"[{headers}]Option[/]").Padding(1,1));
        table.AddColumn(new TableColumn($"[{headers}]Value[/]").Padding(1,1));

        foreach (var pair in options)
        {
            table.AddRow( $"[{label}]{pair.Key}[/]", $"[{value}]{pair.Value}[/]");            
        }
            
        AnsiConsole.Write(table);                            
        AnsiConsole.WriteLine();
        
    }

    public static void ShowRule( string title )
    {

        if(_quiet)
            return;

        var rule = new Rule
        {
            Title = $"[white]{title}[/]",
            Style = Style.Parse("white"),
            Justification = Justify.Left,
        };

        AnsiConsole.Write(rule);
        AnsiConsole.WriteLine();            
        
    }

    public static void ShowProgress( string message, bool includeDuration = true )
    {

        if(_quiet)
            return;
        
        if( includeDuration )
            AnsiConsole.MarkupLine($"[white]    - {Markup.Escape(message)} in {TheStopWatch.ElapsedMilliseconds} msec(s)[/]");
        else
            AnsiConsole.MarkupLine($"[white]    - {Markup.Escape(message)}[/]");

        TheStopWatch.Restart();
        
    }

    public static void ShowCompletion( string command )
    {

        if( _quiet )
            return;

        var duration = TimeSpan.FromTicks(Stopwatch.GetTimestamp() - _startTime).TotalMilliseconds;

        AnsiConsole.WriteLine();
        AnsiConsole.MarkupLine($"[white]{Markup.Escape(command)} completed in {duration} msec(s)[/]");
        
    }
    
    public static void Pause( string message = "Press any key to continue." )
    {

        AnsiConsole.WriteLine();
        AnsiConsole.WriteLine(message);
        Console.ReadKey();
        
    }
    
    public static void ShowError( string message, bool wait=false )
    {

        if(_quiet)
            return;
        
        AnsiConsole.MarkupLine($"[red]{Markup.Escape(message)}[/]");

        AnsiConsole.WriteLine();

        if( wait )
        {
            AnsiConsole.WriteLine("Press any key to exit.");
            Console.ReadKey();
        }

    }
    
    public static void ShowEvents( string title, string groupHeader, string explanationHeader, IEnumerable<RuleEvent> errors, bool wait=false )
    {

        if(_quiet)
            return;

        var headers = "silver";
        var label = "white";
        var value = "red";

        var table = new Table
        {
            Title = new TableTitle(title),
            Border = TableBorder.Rounded,
            BorderStyle = new Style(Color.Silver)
        };

        table.AddColumn(new TableColumn($"[{headers}]{groupHeader}[/]").Padding(1,1));
        table.AddColumn(new TableColumn($"[{headers}]{explanationHeader}[/]").Padding(1,1));

        foreach( var v in errors )
        {
            var name = v.Group.Split('.')[^1];
            table.AddRow( $"[{label}]{name}[/]", $"[{value}]{v.Message}[/]");
        }

        AnsiConsole.Write(table);
        AnsiConsole.WriteLine();

        if( wait )
        {
            AnsiConsole.WriteLine("Press any key to exit.");
            Console.ReadKey();
        }

    }    
    
    public static void ShowException(Exception cause, string message, bool wait= false)
    {

        if(_quiet)
            return;
        
        AnsiConsole.MarkupLine($"[red]{Markup.Escape(message)}[/]");
        AnsiConsole.WriteException(cause);
        
        AnsiConsole.WriteLine();

        if( wait )
        {
            AnsiConsole.WriteLine("Press any key to exit.");
            Console.ReadKey();        
        }
        
    }
   
    
    
    
}