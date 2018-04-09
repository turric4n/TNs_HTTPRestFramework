unit TNsRestFramework.Infrastructure.TaskFactory;

interface

uses
  System.Generics.Collections, SynCommons, System.SysUtils, System.SyncObjs;

type
  TSynBackground = TSynBackgroundTimer;
  TSynBackgroudString = RawUTF8;

  TTask = class(TSynBackgroundTimer)
    private
      FName: string;
      procedure SetName(const Value: string);
    public
      property Name : string read FName write SetName;
      constructor Create(const Name : string);
  end;

  TTaskFactory = class
    private
      fTasks : TObjectlist<TTask>;
    public
      class function NewTask(const Name : string) : TTask;
      class function GetCurrentTasks : TObjectList<TTask>;
      class procedure AddTask(Task : TTask);
      class function GetTask(const Name : string) : TTask;
      class procedure RemoveTask(Task : TTask);
      class procedure Init;
      class function IsThisTaskEnqueued(const Name : string) : Boolean;
  end;

implementation

var
  TaskFactory : TTaskFactory;
  Lock : TCriticalSection;

class function TTaskFactory.GetCurrentTasks : TObjectList<TTask>;
begin
  Lock.Acquire;
  try
    Result := TaskFactory.fTasks;
  finally
    Lock.Release;
  end;
end;


class function TTaskFactory.GetTask(const Name: string): TTask;
var
  task : TTask;
begin
  Result := nil;
  if Assigned(TaskFactory) then
  begin
    if Assigned(TaskFactory.fTasks) then
    for task in GetCurrentTasks do if task.Name = Name then Result := task;
  end;
end;

class procedure TTaskFactory.Init;
begin
  Lock.Acquire;
  Try
    if not Assigned(TaskFactory) then
    begin
      TaskFactory := TTaskFactory.Create;
      TaskFactory.fTasks := TObjectList<TTask>.Create(True);
    end;
  Finally
    Lock.Release;
  End;
end;

class function TTaskFactory.IsThisTaskEnqueued(const Name : string): Boolean;
var
  task : TTask;
begin
  if Assigned(TaskFactory) then
  begin
    if Assigned(TaskFactory.fTasks) then
    begin
      for task in GetCurrentTasks do
      begin
        Result := task.Name = Name;
        if Result then Exit;
      end;
    end;
  end;
end;

class function TTaskFactory.NewTask(const Name : string) : TTask;
begin
  Lock.Acquire;
  Try
    if Assigned(TaskFactory) then
    begin
      if Assigned(TaskFactory.fTasks) then
      begin
        Result := TTask.Create(Name);
        TaskFactory.fTasks.Add(Result);
      end;
    end;
  Finally
    Lock.Release;
  End;
end;

class procedure TTaskFactory.RemoveTask(Task: TTask);
begin
  Lock.Acquire;
  Try
    if Assigned(TaskFactory) then
    begin
      if Assigned(TaskFactory.fTasks) then TaskFactory.fTasks.Remove(Task);
    end;
  Finally
    Lock.Release;
  End;
end;

class procedure TTaskFactory.AddTask(Task : TTask);
begin
  Lock.Acquire;
  Try
    if Assigned(TaskFactory) then
    begin
      if Assigned(TaskFactory.fTasks) then TaskFactory.fTasks.Add(Task);
    end;
  Finally
    Lock.Release;
  End;
end;

{ TTask }

constructor TTask.Create(const Name: string);
begin
  inherited Create(Name);
  FName := Name;
end;

procedure TTask.SetName(const Value: string);
begin
  FName := Name;
end;

initialization
  Lock := TCriticalSection.Create;
  TaskFactory := nil;

finalization
  Lock.Free;
end.
